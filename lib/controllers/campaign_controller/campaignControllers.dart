import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_dashboard/controllers/base_controller/my_controller.dart';
import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignsFirebaseController extends MyController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// COLLECTION NAME
  final String collectionName = "Campaigns";

  RxBool isLoading=false.obs;


  Stream<QuerySnapshot> getCampaignsStream() {
    return _firestore
        .collection(collectionName)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getCampaignById(String docId, BuildContext context) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(docId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      generateMessage("Failed to fetch campaign: $e", context);
      return null;
    }
  }

  Future<bool> updateCampaign({
    required BuildContext context,
    required String docId,
    required String title,
    required String subtitle,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      isLoading.value = true;

      await _firestore.collection(collectionName).doc(docId).update({
        "title": title,
        "subtitle": subtitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        // Keep the same image or update if you implement image editing
      });

      return true;
    } catch (e) {
      generateMessage("Failed to update campaign: $e", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  Future<bool> addCampaign({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      isLoading.value = true;

      // -----------------------------------------------------------
      // 🔍 CHECK IF SAME CAMPAIGN ALREADY EXISTS
      // -----------------------------------------------------------
      final existing = await _firestore
          .collection(collectionName)
          .where("title", isEqualTo: title)
          .where("subtitle", isEqualTo: subtitle)
          .where("startDate", isEqualTo: startDate.toIso8601String())
          .where("endDate", isEqualTo: endDate.toIso8601String())
          .get();

      if (existing.docs.isNotEmpty) {
        generateMessage("Campaign with same details already exists!", context);
        return false;
      }

      // -----------------------------------------------------------
      // 🟢 ADD NEW CAMPAIGN
      // -----------------------------------------------------------
      // Generate a new document reference to get the ID
      final docRef = _firestore.collection(collectionName).doc();
      final campaignId = docRef.id;

      await docRef.set({
        "campaignId": campaignId, // Add campaignId field
        "title": title,
        "subtitle": subtitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "image": "assets/images/compaign1.png",
        "createdAt": DateTime.now().toIso8601String(),
      });

      generateMessage("Campaign added successfully!", context, backgroundColor: kPrimaryGreen);
      return true; // SUCCESS
    } catch (e) {
      generateMessage("Failed to add campaign: $e", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  /// --------------------------------------------------------------
  /// 🔹 EDIT / UPDATE CAMPAIGN
  /// --------------------------------------------------------------
  Future<void> editCampaign({
    required BuildContext context,
    required String docId,
    String? title,
    String? subtitle,
    DateTime? startDate,
    DateTime? endDate,
    String? image,
  }) async {
    isLoading.value=true;
    try {
      Map<String, dynamic> updatedData = {};

      if (title != null) updatedData["title"] = title;
      if (subtitle != null) updatedData["subtitle"] = subtitle;
      if (startDate != null) {
        updatedData["startDate"] = startDate.toIso8601String();
      }
      if (endDate != null) {
        updatedData["endDate"] = endDate.toIso8601String();
      }
      if (image != null) updatedData["image"] = image;

      await _firestore.collection(collectionName).doc(docId).update(updatedData);

      generateMessage("Campaign updated successfully!", context, backgroundColor: kPrimaryGreen);
    } catch (e) {
      generateMessage("Failed to update campaign: $e", context);
    }finally{
      isLoading.value=false;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 DELETE CAMPAIGN
  /// --------------------------------------------------------------
  Future<void> deleteCampaign(BuildContext context, String docId) async {
    isLoading.value=true;
    try {
      await _firestore.collection(collectionName).doc(docId).delete();

      generateMessage("Campaign deleted successfully!", context, backgroundColor: kPrimaryGreen);
    } catch (e) {
      generateMessage("Failed to delete campaign: $e", context);
    }finally{
      isLoading.value=false;
    }
  }

  /// --------------------------------------------------------------
  /// 🔹 GET STREAM OF ALL CAMPAIGNS (Optional - for listing)
  /// --------------------------------------------------------------
}
