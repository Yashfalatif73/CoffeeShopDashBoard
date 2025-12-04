import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// COLLECTION NAME
  final String collectionName = "Vouchers";

  RxBool isLoading = false.obs;

  Stream<QuerySnapshot> getVouchersStream() {
    return _firestore
        .collection(collectionName)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getVoucherById(String docId) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(docId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch voucher: $e");
      return null;
    }
  }

  /// ---------------------------------------------------------
  /// 🔹 UPDATE VOUCHER
  /// ---------------------------------------------------------
  Future<bool> updateVoucher({
    required String docId,
    required String title,
    required String subtitle,
    required double minTransaction,
    required DateTime endDate,
  }) async {
    try {
      isLoading.value = true;

      await _firestore.collection(collectionName).doc(docId).update({
        "title": title,
        "subtitle": subtitle,
        "minTransaction": minTransaction,
        "endDate": endDate.toIso8601String(),
      });

      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to update voucher: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------------
  /// 🔹 ADD NEW VOUCHER
  /// ---------------------------------------------------------
  Future<bool> addVoucher({
    required String title,
    required String subtitle,
    required double minTransaction,
    required DateTime endDate,
  }) async {
    try {
      isLoading.value = true;

      // 🔍 CHECK DUPLICATE VOUCHER
      final existing = await _firestore
          .collection(collectionName)
          .where("title", isEqualTo: title)
          .where("subtitle", isEqualTo: subtitle)
          .where("minTransaction", isEqualTo: minTransaction)
          .where("endDate", isEqualTo: endDate.toIso8601String())
          .get();

      if (existing.docs.isNotEmpty) {
        Get.snackbar(
          "Duplicate",
          "Voucher with same details already exists!",
        );
        return false;
      }

      // 🟢 ADD NEW VOUCHER
      final docRef = _firestore.collection(collectionName).doc();
      final voucherId = docRef.id;

      await docRef.set({
        "voucherId": voucherId,
        "title": title,
        "subtitle": subtitle,
        "minTransaction": minTransaction,
        "endDate": endDate.toIso8601String(),
        "image": "assets/images/compaign1.png",
        "createdAt": DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to add voucher: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------------
  /// 🔹 EDIT VOUCHER
  /// ---------------------------------------------------------
  Future<void> editVoucher({
    required String docId,
    String? title,
    String? subtitle,
    double? minTransaction,
    DateTime? endDate,
    String? image,
  }) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> updatedData = {};

      if (title != null) updatedData["title"] = title;
      if (subtitle != null) updatedData["subtitle"] = subtitle;
      if (minTransaction != null) updatedData["minTransaction"] = minTransaction;
      if (endDate != null) {
        updatedData["endDate"] = endDate.toIso8601String();
      }
      if (image != null) updatedData["image"] = image;

      await _firestore.collection(collectionName).doc(docId).update(updatedData);

      Get.snackbar("Updated", "Voucher updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update voucher: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------------------------------------------------
  /// 🔹 DELETE VOUCHER
  /// ---------------------------------------------------------
  Future<void> deleteVoucher(String docId) async {
    isLoading.value = true;
    try {
      await _firestore.collection(collectionName).doc(docId).delete();

      Get.snackbar("Deleted", "Voucher deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete voucher: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
