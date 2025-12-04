import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/core/services/date_picker_service.dart';
import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/campaign_controller/campaignControllers.dart';
import '../../core/helpers/colors.dart';
import '../../widgets/my_widgets/my_button.dart';
import '../../widgets/my_widgets/my_text.dart';

class AddCampaignScreen extends StatefulWidget {
  final String? docId;

  const AddCampaignScreen({super.key, this.docId});

  @override
  State<AddCampaignScreen> createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  final TextEditingController titleController1 = TextEditingController();
  final TextEditingController titleController2 = TextEditingController();

  final campaignsController = Get.find<CampaignsFirebaseController>();

  @override
  void initState() {
    super.initState();

    if (widget.docId != null) {
      // Fetch document data
      campaignsController.getCampaignById(widget.docId!).then((data) {
        if (data != null) {
          setState(() {
            titleController1.text = data["title"] ?? "";
            titleController2.text = data["subtitle"] ?? "";
            startDate = DateTime.tryParse(data["startDate"] ?? "");
            endDate = DateTime.tryParse(data["endDate"] ?? "");
            // Image field (if needed)
            uploadedImageName = data["image"]?.split("/").last ?? "";
          });
        }
      });
    }
  }



  DateTime? startDate;
  DateTime? endDate;

  Uint8List? uploadedImageBytes;
  String? uploadedImageName;

  Future<void> pickStartDate() async {
    final pickedDate = await DatePickerService.showThemedDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      helpText: 'Select Starting Date',
    );
    if (pickedDate != null) {
      setState(() => startDate = pickedDate);
    }
  }

  Future<void> pickEndDate() async {
    final pickedDate = await DatePickerService.showThemedDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: startDate, // End date can't be before start date
      helpText: 'Select End Date',
    );
    if (pickedDate != null) {
      setState(() => endDate = pickedDate);
    }
  }

  Future<void> uploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        uploadedImageBytes = result.files.single.bytes;
        uploadedImageName = result.files.single.name;
      });
    }
  }

  Widget dateBox(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  date == null
                      ? "Select date"
                      : DatePickerService.formatDate(date),
                  style: const TextStyle(fontSize: 14),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 18, color: kPrimaryGreen),
              ],
            ),
          ),
        )
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(
        builder: (_, __, type) {
          return MyFlex(
            contentPadding: true,
            children: [
              MyFlexItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add New Campaign",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // --------------- Title & Date 1 --------------------
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Title"),
                              const SizedBox(height: 6),
                              TextField(
                                controller: titleController1,
                                decoration: InputDecoration(
                                  hintText: "Enter campaign title",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: dateBox("Starting Date", startDate, pickStartDate),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --------------- Title & Date 2 --------------------
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Title"),
                              const SizedBox(height: 6),
                              TextField(
                                controller: titleController2,
                                decoration: InputDecoration(
                                  hintText: "Enter campaign title",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: dateBox("End Date", endDate, pickEndDate),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ---------------- Image Upload Box ----------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1.4),
                        color: Colors.grey.shade50,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Upload Ad Image",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Drag and drop or browse to upload",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: uploadImage,
                            icon: const Icon(Icons.upload),
                            label: const Text("Upload"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B462D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),

                          if (uploadedImageBytes != null) ...[
                            const SizedBox(height: 20),
                            Text("Selected: $uploadedImageName"),
                          ]
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ---------------- Buttons ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 34, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Obx(() => campaignsController.isLoading.value
                            ? CircularProgressIndicator(color: kPrimaryGreen)
                            : MyButton.large(
                          backgroundColor: kPrimaryGreen,
                          onPressed: () async {
                            if (titleController1.text.isEmpty ||
                                titleController2.text.isEmpty ||
                                startDate == null ||
                                endDate == null) {
                              Get.snackbar("Error", "Please fill all fields");
                              return;
                            }

                            bool success;

                            if (widget.docId != null) {
                              // ⬅ Edit mode
                              success = await campaignsController.updateCampaign(
                                docId: widget.docId!,
                                title: titleController1.text.trim(),
                                subtitle: titleController2.text.trim(),
                                startDate: startDate!,
                                endDate: endDate!,
                              );
                            } else {
                              // ⬅ Add mode
                              success = await campaignsController.addCampaign(
                                title: titleController1.text.trim(),
                                subtitle: titleController2.text.trim(),
                                startDate: startDate!,
                                endDate: endDate!,
                              );
                            }

                            if (success) {
                              /// CLEAR EVERYTHING
                              titleController1.clear();
                              titleController2.clear();
                              setState(() {
                                startDate = null;
                                endDate = null;
                                uploadedImageBytes = null;
                                uploadedImageName = null;
                              });

                              if (context.mounted) {
                                context.beamToNamed('/campaigns');
                              }
                            }
                          },
                          child: Center(
                            child: MyText.bodyLarge(
                              widget.docId != null ? 'Update' : 'Create',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
