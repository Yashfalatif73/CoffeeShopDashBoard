import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_dashboard/controllers/VoucherController/voucherController.dart';
import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
import 'package:coffee_shop_dashboard/core/services/date_picker_service.dart';
import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/dialogs/confirmation_dialog.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_card.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/my_widgets/my_button.dart';

class VoucherListPage extends StatefulWidget {
  const VoucherListPage({super.key});

  @override
  State<VoucherListPage> createState() => _VoucherListPageState();
}

class _VoucherListPageState extends State<VoucherListPage> {
  final voucherController = Get.put(VoucherController());

  // -------------------- EDIT DIALOG FUNCTION --------------------
  void showEditVoucherDialog(BuildContext context, String docId) async {
    // Fetch voucher data first
    final data = await voucherController.getVoucherById(docId);
    if (data == null) return;

    // Local controllers for the dialog
    final TextEditingController titleController =
    TextEditingController(text: data["title"] ?? "");
    final TextEditingController subtitleController =
    TextEditingController(text: data["subtitle"] ?? "");
    final TextEditingController minTransactionController =
    TextEditingController(text: data["minTransaction"]?.toString() ?? "");

    DateTime? endDate = DateTime.tryParse(data["endDate"] ?? "");

    // Helper function
    Future<void> pickEndDate() async {
      final pickedDate = await DatePickerService.showThemedDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        helpText: 'Select End Date',
      );
      if (pickedDate != null) endDate = pickedDate;
    }

    // Show Dialog

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              // Ensure minTransaction is converted to string
              final TextEditingController minTransactionController =
              TextEditingController(
                  text: data["minTransaction"]?.toString() ?? "");

              return SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kLightGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit,
                                color: kPrimaryGreen, size: 24),
                          ),
                          const SizedBox(width: 12),
                          MyText("Edit Voucher",
                              fontSize: 20, fontWeight: 700),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Title
                      MyText("Title", fontSize: 14, fontWeight: 600),
                      const SizedBox(height: 6),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      MyText("Subtitle", fontSize: 14, fontWeight: 600),
                      const SizedBox(height: 6),
                      TextField(
                        controller: subtitleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Min Transaction
                      MyText("Min Transaction", fontSize: 14, fontWeight: 600),
                      const SizedBox(height: 6),
                      TextField(
                        controller: minTransactionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      // End Date
                      MyText("End Date", fontSize: 14, fontWeight: 600),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          await pickEndDate();
                          setStateDialog(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                endDate == null
                                    ? "Select date"
                                    : DatePickerService.formatDate(endDate),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today,
                                  size: 18, color: kPrimaryGreen),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: MyText("Cancel", fontWeight: 600),
                          ),
                          const SizedBox(width: 16),
                          Obx(() => voucherController.isLoading.value
                              ? const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24),
                            child: CircularProgressIndicator(
                                color: kPrimaryGreen),
                          )
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (titleController.text.isEmpty ||
                                  subtitleController.text.isEmpty ||
                                  minTransactionController.text.isEmpty ||
                                  endDate == null) {
                                Get.snackbar(
                                    "Error", "Please fill all fields");
                                return;
                              }

                              final double? minTransactionValue =
                              double.tryParse(minTransactionController
                                  .text
                                  .trim());
                              if (minTransactionValue == null) {
                                Get.snackbar("Error",
                                    "Enter a valid min transaction value");
                                return;
                              }

                              bool success = await voucherController
                                  .updateVoucher(
                                docId: docId,
                                title: titleController.text.trim(),
                                subtitle: subtitleController.text.trim(),
                                minTransaction: minTransactionValue,
                                endDate: endDate!,
                              );

                              if (success) {
                                Get.snackbar(
                                    "Success",
                                    "Voucher updated successfully");
                                Navigator.pop(context);
                              }
                            },
                            child: MyText("Update",
                                color: colorWhite, fontWeight: 600),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );


    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (_) {
    //     return AlertDialog(
    //       backgroundColor: colorWhite,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       contentPadding: const EdgeInsets.all(24),
    //       content: StatefulBuilder(
    //         builder: (context, setStateDialog) {
    //           return SizedBox(
    //             width: 600,
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Container(
    //                         padding: const EdgeInsets.all(8),
    //                         decoration: BoxDecoration(
    //                           color: kLightGreen,
    //                           borderRadius: BorderRadius.circular(8),
    //                         ),
    //                         child: const Icon(Icons.edit,
    //                             color: kPrimaryGreen, size: 24),
    //                       ),
    //                       const SizedBox(width: 12),
    //                       MyText("Edit Voucher",
    //                           fontSize: 20, fontWeight: 700),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 24),
    //                   // Title
    //                   MyText("Title", fontSize: 14, fontWeight: 600),
    //                   const SizedBox(height: 6),
    //                   TextField(
    //                     controller: titleController,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       contentPadding: const EdgeInsets.symmetric(
    //                           horizontal: 16, vertical: 14),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 16),
    //                   // Subtitle
    //                   MyText("Subtitle", fontSize: 14, fontWeight: 600),
    //                   const SizedBox(height: 6),
    //                   TextField(
    //                     controller: subtitleController,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       contentPadding: const EdgeInsets.symmetric(
    //                           horizontal: 16, vertical: 14),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 16),
    //                   // Min Transaction
    //                   MyText("Min Transaction", fontSize: 14, fontWeight: 600),
    //                   const SizedBox(height: 6),
    //                   TextField(
    //                     controller: minTransactionController,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       contentPadding: const EdgeInsets.symmetric(
    //                           horizontal: 16, vertical: 14),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 16),
    //                   // End Date
    //                   MyText("End Date", fontSize: 14, fontWeight: 600),
    //                   const SizedBox(height: 6),
    //                   InkWell(
    //                     onTap: () async {
    //                       await pickEndDate();
    //                       setStateDialog(() {});
    //                     },
    //                     child: Container(
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 16, vertical: 14),
    //                       decoration: BoxDecoration(
    //                         border: Border.all(color: Colors.grey.shade300),
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           Text(
    //                             endDate == null
    //                                 ? "Select date"
    //                                 : DatePickerService.formatDate(endDate),
    //                             style: const TextStyle(fontSize: 14),
    //                           ),
    //                           const Spacer(),
    //                           const Icon(Icons.calendar_today,
    //                               size: 18, color: kPrimaryGreen),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(height: 24),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       OutlinedButton(
    //                         onPressed: () => Navigator.pop(context),
    //                         style: OutlinedButton.styleFrom(
    //                           side: BorderSide(color: Colors.grey.shade300),
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 24, vertical: 12),
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(8),
    //                           ),
    //                         ),
    //                         child: MyText("Cancel", fontWeight: 600),
    //                       ),
    //                       const SizedBox(width: 16),
    //                       Obx(() => voucherController.isLoading.value
    //                           ? const Padding(
    //                         padding:
    //                         EdgeInsets.symmetric(horizontal: 24),
    //                         child: CircularProgressIndicator(
    //                             color: kPrimaryGreen),
    //                       )
    //                           : ElevatedButton(
    //                         style: ElevatedButton.styleFrom(
    //                           backgroundColor: kPrimaryGreen,
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 24, vertical: 12),
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(8),
    //                           ),
    //                         ),
    //                         onPressed: () async {
    //                           if (titleController.text.isEmpty ||
    //                               subtitleController.text.isEmpty ||
    //                               minTransactionController.text.isEmpty ||
    //                               endDate == null) {
    //                             Get.snackbar(
    //                                 "Error", "Please fill all fields");
    //                             return;
    //                           }
    //
    //                           final double? minTransactionValue = double.tryParse(minTransactionController.text.trim());
    //                           if (minTransactionValue == null) {
    //                             Get.snackbar("Error", "Enter a valid min transaction value");
    //                             return;
    //                           }
    //
    //                           bool success = await voucherController.updateVoucher(
    //                             docId: docId,
    //                             title: titleController.text.trim(),
    //                             subtitle: subtitleController.text.trim(),
    //                             minTransaction: minTransactionValue,
    //                             endDate: endDate!,
    //                           );
    //
    //                           if (success) {
    //                             Get.snackbar(
    //                                 "Success",
    //                                 "Voucher updated successfully");
    //                             Navigator.pop(context);
    //                           }
    //                         },
    //                         child: MyText("Update",
    //                             color: colorWhite, fontWeight: 600),
    //                       )),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(builder: (_, __, type) {
        return MyFlex(
          children: [
            MyFlexItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText("Voucher", fontSize: 20, fontWeight: 700),
                      MyButton(
                        onPressed: () {
                          context.beamToNamed('/add-voucher');
                        },
                        borderRadiusAll: 10,
                        msPadding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: MyText(
                          "+ Create Voucher",
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<QuerySnapshot>(
                    stream: voucherController.getVouchersStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                            CircularProgressIndicator(color: kPrimaryGreen));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No Vouchers found"));
                      }

                      final vouchers = snapshot.data!.docs;

                      return MyCard(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 200,
                            columns: [
                              DataColumn(
                                  label: MyText("Title",
                                      fontSize: 14, fontWeight: 700)),
                              DataColumn(
                                  label: MyText("Min Transaction",
                                      fontSize: 14, fontWeight: 700)),
                              DataColumn(
                                  label: MyText("End Date",
                                      fontSize: 14, fontWeight: 700)),
                              DataColumn(
                                  label: MyText("Actions",
                                      fontSize: 14, fontWeight: 700)),
                            ],
                            rows: vouchers.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final title = data["title"] ?? "";
                              final minTransaction = data["minTransaction"] ?? 0.0;
                              final endDateStr = data["endDate"] ?? "";
                              final endDate = DateTime.tryParse(endDateStr);

                              return DataRow(cells: [
                                DataCell(MyText(title, fontSize: 14)),
                                DataCell(MyText(minTransaction.toStringAsFixed(2), fontSize: 14)),
                                DataCell(MyText(
                                  DatePickerService.formatDate(endDate),
                                  fontSize: 14,
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showEditVoucherDialog(context, doc.id);
                                      },
                                      icon: Icon(Icons.edit, color: kPrimaryGreen),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ConfirmationDialog(
                                              title: "Delete Voucher?",
                                              message:
                                              "Are you sure you want to delete this voucher? This action cannot be undone.",
                                              confirmBtnText: "Delete",
                                              cancelBtnText: "Cancel",
                                              onConfirm: () {
                                                voucherController.deleteVoucher(doc.id);
                                                Navigator.of(context).pop();
                                              },
                                              onCancel: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete, color: colorRed),
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}




// import 'package:beamer/beamer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coffee_shop_dashboard/controllers/VoucherController/voucherController.dart';
// import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
// import 'package:coffee_shop_dashboard/core/services/date_picker_service.dart';
// import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
// import 'package:coffee_shop_dashboard/widgets/dialogs/confirmation_dialog.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_card.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/campaign_controller/campaignControllers.dart';
// import '../../widgets/my_widgets/my_button.dart';
//
// class VoucherListPage extends StatefulWidget {
//   const VoucherListPage({super.key});
//
//   @override
//   State<VoucherListPage> createState() => _CampaignsListPageState();
// }
//
// class _CampaignsListPageState extends State<VoucherListPage> {
//   final voucherController = Get.put(VoucherController());
//
//   // -------------------- EDIT DIALOG FUNCTION --------------------
//   void showEditCampaignDialog(BuildContext context, String docId) async {
//     // Fetch campaign data first
//     final data = await voucherController.getVoucherById(docId);
//     if (data == null) return;
//
//     // Local controllers for the dialog
//     final TextEditingController titleController1 =
//     TextEditingController(text: data["title"] ?? "");
//     final TextEditingController titleController2 =
//     TextEditingController(text: data["subtitle"] ?? "");
//     DateTime? startDate = DateTime.tryParse(data["startDate"] ?? "");
//     DateTime? endDate = DateTime.tryParse(data["endDate"] ?? "");
//
//     // Helper functions
//     Future<void> pickStartDate() async {
//       final pickedDate = await DatePickerService.showThemedDatePicker(
//         context: context,
//         initialDate: startDate ?? DateTime.now(),
//         helpText: 'Select Starting Date',
//       );
//       if (pickedDate != null) startDate = pickedDate;
//     }
//
//     Future<void> pickEndDate() async {
//       final pickedDate = await DatePickerService.showThemedDatePicker(
//         context: context,
//         initialDate: endDate ?? startDate ?? DateTime.now(),
//         firstDate: startDate, // End date can't be before start date
//         helpText: 'Select End Date',
//       );
//       if (pickedDate != null) endDate = pickedDate;
//     }
//
//     // Show Dialog
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) {
//         return AlertDialog(
//           backgroundColor: colorWhite,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           contentPadding: const EdgeInsets.all(24),
//           content: StatefulBuilder(
//             builder: (context, setStateDialog) {
//               // Date picker widget
//               Widget dateBox(
//                   String label, DateTime? date, Future<void> Function() onTap) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     MyText(label, fontSize: 14, fontWeight: 600),
//                     const SizedBox(height: 6),
//                     InkWell(
//                       onTap: () async {
//                         await onTap();
//                         setStateDialog(() {}); // Refresh dialog UI
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 14),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               date == null
//                                   ? "Select date"
//                                   : DatePickerService.formatDate(date),
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             const Spacer(),
//                             const Icon(Icons.calendar_today, size: 18, color: kPrimaryGreen),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 );
//               }
//
//               return SizedBox(
//                 width: 600,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: kLightGreen,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(Icons.edit, color: kPrimaryGreen, size: 24),
//                           ),
//                           const SizedBox(width: 12),
//                           MyText("Edit Campaign", fontSize: 20, fontWeight: 700),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 MyText("Title", fontSize: 14, fontWeight: 600),
//                                 const SizedBox(height: 6),
//                                 TextField(
//                                   controller: titleController1,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 14
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 30),
//                           Expanded(
//                               child:
//                               dateBox("Starting Date", startDate, pickStartDate)),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 MyText("Subtitle", fontSize: 14, fontWeight: 600),
//                                 const SizedBox(height: 6),
//                                 TextField(
//                                   controller: titleController2,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 14
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 30),
//                           Expanded(child: dateBox("End Date", endDate, pickEndDate)),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(12),
//                           color: kLightGreen.withOpacity(0.3),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.info_outline, color: kPrimaryGreen),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: MyText(
//                                 "Image upload feature coming soon. Current image will be preserved.",
//                                 fontSize: 13,
//                                 color: kPrimaryGreen,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(color: Colors.grey.shade300),
//                               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: MyText("Cancel", fontWeight: 600),
//                           ),
//                           const SizedBox(width: 16),
//                           Obx(() => voucherController.isLoading.value
//                               ? const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 24),
//                             child: CircularProgressIndicator(color: kPrimaryGreen),
//                           )
//                               : ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: kPrimaryGreen,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 24, vertical: 12
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             onPressed: () async {
//                               if (titleController1.text.isEmpty ||
//                                   titleController2.text.isEmpty ||
//                                   startDate == null ||
//                                   endDate == null) {
//                                 Get.snackbar(
//                                     "Error", "Please fill all fields");
//                                 return;
//                               }
//
//                               bool success =
//                               await voucherController.updateVoucher(
//                                 docId: docId,
//                                 title: titleController1.text.trim(),
//                                 subtitle: titleController2.text.trim(),
//                                 startDate: startDate!,
//                                 endDate: endDate!,
//                               );
//
//                               if (success) {
//                                 Get.snackbar(
//                                     "Success", "Campaign updated successfully");
//                                 Navigator.pop(context);
//                               }
//                             },
//                             child: MyText("Update", color: colorWhite, fontWeight: 600),
//                           )),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   // -------------------- BUILD --------------------
//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: MyResponsive(builder: (_, __, type) {
//         return MyFlex(
//           children: [
//             MyFlexItem(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       MyText("Voucher", fontSize: 20, fontWeight: 700),
//                       MyButton(
//                         onPressed: () {
//                           context.beamToNamed('/add-voucher');
//                         },
//                         borderRadiusAll: 10,
//                         msPadding: WidgetStateProperty.all(
//                           const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         child: MyText(
//                           "+ Create Voucher",
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: voucherController.getVouchersStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(
//                             child: CircularProgressIndicator(color: kPrimaryGreen));
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return Center(child: Text("No Vouchers found"));
//                       }
//
//                       final campaigns = snapshot.data!.docs;
//
//                       return MyCard(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             columnSpacing: 200,
//                             columns: [
//                               DataColumn(
//                                   label:
//                                   MyText("Title", fontSize: 14, fontWeight: 700)),
//                               DataColumn(
//                                   label: MyText("Start Date",
//                                       fontSize: 14, fontWeight: 700)),
//                               DataColumn(
//                                   label: MyText("End Date",
//                                       fontSize: 14, fontWeight: 700)),
//                               DataColumn(
//                                   label: MyText("Actions",
//                                       fontSize: 14, fontWeight: 700)),
//                             ],
//                             rows: campaigns.map((doc) {
//                               final data = doc.data() as Map<String, dynamic>;
//                               final title = data["title"] ?? "";
//                               final startDateStr = data["startDate"] ?? "";
//                               final endDateStr = data["endDate"] ?? "";
//
//                               final startDate = DateTime.tryParse(startDateStr);
//                               final endDate = DateTime.tryParse(endDateStr);
//
//                               return DataRow(cells: [
//                                 DataCell(MyText(title, fontSize: 14)),
//                                 DataCell(MyText(
//                                   DatePickerService.formatDate(startDate),
//                                   fontSize: 14,
//                                 )),
//                                 DataCell(MyText(
//                                   DatePickerService.formatDate(endDate),
//                                   fontSize: 14,
//                                 )),
//                                 DataCell(Row(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         showEditCampaignDialog(context, doc.id);
//                                       },
//                                       icon: Icon(Icons.edit, color: kPrimaryGreen),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return ConfirmationDialog(
//                                               title: "Delete Campaign?",
//                                               message: "Are you sure you want to delete this\ncampaign? This action cannot be undone.",
//                                               confirmBtnText: "Delete",
//                                               cancelBtnText: "Cancel",
//                                               onConfirm: () {
//                                                 voucherController.deleteVoucher(doc.id);
//                                                 Navigator.of(context).pop();
//                                               },
//                                               onCancel: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                             );
//                                           },
//                                         );
//                                       },
//                                       icon: Icon(Icons.delete, color: colorRed),
//                                     ),
//                                   ],
//                                 )),
//                               ]);
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
