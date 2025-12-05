import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_dashboard/controllers/product_controller.dart';
import 'package:coffee_shop_dashboard/models/product_model.dart';
import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/dialogs/confirmation_dialog.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_card.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/helpers/colors.dart';
import '../../widgets/my_widgets/my_button.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(
        builder: (_, __, type){
          return MyFlex(
            contentPadding: true,
            children: [
              MyFlexItem(
                child: _buildProductList()
              )
            ]
          );
        }
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOP BAR
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              "Products",
              fontSize: 24,
              fontWeight: 700,
            ),

            MyButton(
              onPressed: (){
                productController.clearForm();
                context.beamToNamed('/add-product');
              },
              borderRadiusAll: 10,
              msPadding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: MyText("+ Add new Product", color: Colors.white,),
            ),
          ],
        ),

        const SizedBox(height: 26),

        // STREAM BUILDER FOR REAL-TIME PRODUCT DATA
        StreamBuilder<QuerySnapshot>(
          stream: productController.getProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: kPrimaryGreen),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      MyText("No products found", fontSize: 16, color: Colors.grey),
                      const SizedBox(height: 8),
                      MyText("Click 'Add new Product' to create your first product", 
                        fontSize: 14, 
                        color: Colors.grey.shade600
                      ),
                    ],
                  ),
                ),
              );
            }

            final products = snapshot.data!.docs;

            return MyCard(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 30,
                  headingRowHeight: 56,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 70,
                  columns: [
                    DataColumn(label: MyText("#", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Product Name", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Category", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Image", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Size", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Quantity", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Price", fontSize: 14, fontWeight: 700)),
                    DataColumn(label: MyText("Actions", fontSize: 14, fontWeight: 700)),
                  ],
                  rows: products.asMap().entries.map((entry) {
                    final index = entry.key;
                    final doc = entry.value;
                    final data = doc.data() as Map<String, dynamic>;
                    
                    // Convert to ProductModel
                    final product = ProductModel.fromJson(data);

                    return DataRow(
                      cells: [
                        // NUMBER
                        DataCell(
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryGreen.withOpacity(0.2)
                            ),
                            child: Center(
                              child: MyText('${index + 1}', fontSize: 14, color: kPrimaryGreen, fontWeight: 600),
                            ),
                          ),
                        ),
                        
                        // NAME
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: MyText(product.name, fontSize: 14, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        
                        // CATEGORY
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: MyText(product.getCategoryDisplayText(), fontSize: 14, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        
                        // IMAGE
                        DataCell(
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: kLightGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.coffee, size: 24, color: kPrimaryGreen),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // SIZE
                        DataCell(MyText(product.getSizeDisplayText(), fontSize: 14)),
                        
                        // QUANTITY
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: product.quantity < 10 
                                ? Colors.red.withOpacity(0.1) 
                                : kLightGreen.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: MyText(
                              product.quantity.toString(), 
                              fontSize: 14, 
                              fontWeight: 600,
                              color: product.quantity < 10 ? colorRed : kPrimaryGreen,
                            ),
                          ),
                        ),
                        
                        // PRICE
                        DataCell(
                          MyText("\$${product.price}", fontSize: 14, fontWeight: 700, color: kPrimaryGreen),
                        ),
                        
                        // ACTIONS
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20, color: kPrimaryGreen),
                                onPressed: () => _showEditProductDialog(context, doc.id, product),
                                tooltip: "Edit Product",
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: colorRed),
                                onPressed: () => _showDeleteConfirmation(context, doc.id, product.name),
                                tooltip: "Delete Product",
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// --------------------------------------------------------------
  /// EDIT PRODUCT DIALOG
  /// --------------------------------------------------------------
  void _showEditProductDialog(BuildContext context, String docId, ProductModel product) {
    // Load data into controller
    productController.loadProductData(product);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kLightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: kPrimaryGreen, size: 24),
              ),
              const SizedBox(width: 12),
              MyText("Edit Product", fontWeight: 700, fontSize: 20),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: AddProductForm(
                controller: productController,
                isEditMode: true,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    productController.clearForm();
                    Navigator.pop(dialogContext);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: MyText("Cancel", fontWeight: 600),
                ),
                const SizedBox(width: 12),
                Obx(() => productController.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: CircularProgressIndicator(color: kPrimaryGreen),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          bool success = await productController.updateProduct(
                            context: context,
                            docId: docId,
                            name: productController.nameController.text,
                            price: productController.priceController.text,
                            category: productController.selectedCategory.value,
                            quantity: productController.quantityController.text,
                            subCategory: productController.selectedSubCategory.value,
                            availableIn: productController.selectedAvailable.value,
                            size: productController.selectedSize.value,
                          );

                          if (success) {
                            productController.clearForm();
                            Navigator.pop(dialogContext);
                          }
                        },
                        child: MyText("Update", color: colorWhite, fontWeight: 600),
                      )),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String docId, String productName) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmationDialog(
          title: "Delete Product?",
          message: "Are you sure you want to delete\n'$productName'? This action cannot be undone.",
          confirmBtnText: "Delete",
          cancelBtnText: "Cancel",
          onConfirm: () {
            productController.deleteProduct(context, docId);
            Navigator.pop(dialogContext);
          },
          onCancel: () {
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

}

class AddProductForm extends StatelessWidget {
  final ProductController controller;
  final bool isEditMode;

  const AddProductForm({
    super.key,
    required this.controller,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NAME + PRICE
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText("Product Name *", fontWeight: 700),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: "Enter product name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText("Price *", fontWeight: 700),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Enter price",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // QUANTITY
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText("Quantity *", fontWeight: 700),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter quantity",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()), // Empty space for alignment
          ],
        ),

        const SizedBox(height: 16),

        // QUANTITY
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText("Quantity *", fontWeight: 700),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter quantity",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()), // Empty space for alignment
          ],
        ),

        const SizedBox(height: 16),

        // CATEGORY
        Obx(() => _buildDropdown(
          label: "Category *",
          value: controller.selectedCategory.value,
          items: controller.categories,
          onChanged: (value) {
            if (value != null) {
              controller.selectedCategory.value = value;
            }
          },
        )),

        const SizedBox(height: 16),

        // COFFEE-SPECIFIC FIELDS
        Obx(() {
          if (controller.selectedCategory.value == "Coffee") {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: "Sub Category",
                        value: controller.selectedSubCategory.value,
                        items: controller.subCategories,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedSubCategory.value = value;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        label: "Available In",
                        value: controller.selectedAvailable.value,
                        items: controller.availableIn,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedAvailable.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Size",
                  value: controller.selectedSize.value,
                  items: controller.sizes,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedSize.value = value;
                    }
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(label, fontWeight: 700),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E2E2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: colorWhite,
              hint: const Text("Select"),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              onChanged: onChanged,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
          ),
        )
      ],
    );
  }
}

