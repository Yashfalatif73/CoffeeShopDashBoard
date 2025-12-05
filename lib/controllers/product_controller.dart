import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_dashboard/controllers/base_controller/my_controller.dart';
import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
import 'package:coffee_shop_dashboard/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductController extends MyController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// COLLECTION NAME
  final String collectionName = "Products";

  RxBool isLoading = false.obs;

  RxString selectedCategory = "Select".obs;
  RxString selectedSubCategory = "Simple Latte".obs;
  RxString selectedAvailable = "Hot".obs;
  RxString selectedSize = "Small".obs;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  // Lists from your screenshot
  final List<String> categories = [
    "Select",
    "Coffee",
    "Sandwich",
    "Desert",
    "Drinks",
    "Grocery Item",
  ];

  final List<String> subCategories = [
    "Simple Latte",
    "Iced Latte",
    "Cappuccino",
    "Signature Coffee",
    "Americano",
    "Espresso",
    "Flat White",
    "Macchiato",
    "Mocha",
    "Affogato",
  ];

  final List<String> availableIn = ["Hot", "Iced", "Both"];
  final List<String> sizes = ["Small", "Medium", "Large"];

  /// --------------------------------------------------------------
  /// 🔹 GET PRODUCTS STREAM (Real-time updates)
  /// --------------------------------------------------------------
  Stream<QuerySnapshot> getProductsStream() {
    return _firestore
        .collection(collectionName)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// --------------------------------------------------------------
  /// 🔹 GET PRODUCT BY ID
  /// --------------------------------------------------------------
  Future<ProductModel?> getProductById(String docId, BuildContext context) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(docId).get();
      if (doc.exists && doc.data() != null) {
        return ProductModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      generateMessage("Failed to fetch product: $e", context);
      return null;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 ADD NEW PRODUCT
  /// --------------------------------------------------------------
  Future<bool> addProduct({
    required BuildContext context,
    required String name,
    required String price,
    required String category,
    required String quantity,
    String? subCategory,
    String? availableIn,
    String? size,
  }) async {
    try {
      isLoading.value = true;

      // Validation
      if (name.isEmpty || price.isEmpty || category == "Select" || quantity.isEmpty) {
        generateMessage("Please fill all required fields", context);
        return false;
      }

      // Parse quantity
      final int? parsedQuantity = int.tryParse(quantity);
      if (parsedQuantity == null || parsedQuantity < 0) {
        generateMessage("Please enter a valid quantity (0 or greater)", context);
        return false;
      }

      // Check for duplicate product
      final existing = await _firestore
          .collection(collectionName)
          .where("name", isEqualTo: name)
          .where("category", isEqualTo: category)
          .get();

      if (existing.docs.isNotEmpty) {
        generateMessage("Product with same name and category already exists!", context);
        return false;
      }

      // Placeholder image URL (since Firebase Storage is not available)
      const String placeholderImage = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400";

      // Generate a new document reference to get the ID
      final docRef = _firestore.collection(collectionName).doc();
      final productId = docRef.id;

      // Create product model
      final product = ProductModel(
        productId: productId,
        name: name,
        price: price,
        category: category,
        quantity: parsedQuantity,
        image: placeholderImage,
        subCategory: category == "Coffee" ? (subCategory ?? "Simple Latte") : null,
        availableIn: category == "Coffee" ? (availableIn ?? "Hot") : null,
        size: category == "Coffee" ? (size ?? "Medium") : null,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Add to Firestore using the generated document reference
      await docRef.set(product.toJson());
      generateMessage("Product added successfully!", context, backgroundColor: kPrimaryGreen);
      return true;
    } catch (e) {
      generateMessage("Failed to add product: $e", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 UPDATE PRODUCT
  /// --------------------------------------------------------------
  Future<bool> updateProduct({
    required BuildContext context,
    required String docId,
    required String name,
    required String price,
    required String category,
    required String quantity,
    String? subCategory,
    String? availableIn,
    String? size,
  }) async {
    try {
      isLoading.value = true;

      // Validation
      if (name.isEmpty || price.isEmpty || category == "Select" || quantity.isEmpty) {
        generateMessage("Please fill all required fields", context);
        return false;
      }

      // Parse quantity
      final int? parsedQuantity = int.tryParse(quantity);
      if (parsedQuantity == null || parsedQuantity < 0) {
        generateMessage("Please enter a valid quantity (0 or greater)", context);
        return false;
      }

      Map<String, dynamic> updatedData = {
        "name": name,
        "price": price,
        "category": category,
        "quantity": parsedQuantity,
      };

      // Add optional fields if category is Coffee
      if (category == "Coffee") {
        updatedData["subCategory"] = subCategory ?? "Simple Latte";
        updatedData["availableIn"] = availableIn ?? "Hot";
        updatedData["size"] = size ?? "Medium";
      } else {
        // Remove coffee-specific fields if category changed
        updatedData["subCategory"] = FieldValue.delete();
        updatedData["availableIn"] = FieldValue.delete();
        updatedData["size"] = FieldValue.delete();
      }

      await _firestore.collection(collectionName).doc(docId).update(updatedData);

      generateMessage("Product updated successfully!", context, backgroundColor: kPrimaryGreen);
      return true;
    } catch (e) {
      generateMessage("Failed to update product: $e", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 DELETE PRODUCT
  /// --------------------------------------------------------------
  Future<void> deleteProduct(BuildContext context, String docId) async {
    isLoading.value = true;
    try {
      await _firestore.collection(collectionName).doc(docId).delete();
      generateMessage("Product deleted successfully!", context, backgroundColor: kPrimaryGreen);
    } catch (e) {
      generateMessage("Failed to delete product: $e", context);
    } finally {
      isLoading.value = false;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 CLEAR FORM
  /// --------------------------------------------------------------
  void clearForm() {
    nameController.clear();
    priceController.clear();
    quantityController.clear();
    selectedCategory.value = "Select";
    selectedSubCategory.value = "Simple Latte";
    selectedAvailable.value = "Hot";
    selectedSize.value = "Small";
  }

  /// --------------------------------------------------------------
  /// 🔹 LOAD PRODUCT DATA FOR EDITING
  /// --------------------------------------------------------------
  void loadProductData(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price;
    quantityController.text = product.quantity.toString();
    selectedCategory.value = product.category;
    
    if (product.category == "Coffee") {
      selectedSubCategory.value = product.subCategory ?? "Simple Latte";
      selectedAvailable.value = product.availableIn ?? "Hot";
      selectedSize.value = product.size ?? "Small";
    }
  }

}