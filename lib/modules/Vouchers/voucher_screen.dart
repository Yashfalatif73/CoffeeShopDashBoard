import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/controllers/VoucherController/voucherController.dart';
import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVoucherScreen extends StatefulWidget {
  final String? docId;

  const AddVoucherScreen({super.key, this.docId});

  @override
  State<AddVoucherScreen> createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController minTransactionController = TextEditingController();

  DateTime? endDate;

  final voucherController = Get.find<VoucherController>();

  Uint8List? uploadedImageBytes;
  String? uploadedImageName;

  @override
  void initState() {
    super.initState();

    if (widget.docId != null) {
      // Fetch voucher data
      voucherController.getVoucherById(widget.docId!).then((data) {
        if (data != null) {
          setState(() {
            titleController.text = data["title"] ?? "";
            subtitleController.text = data["subtitle"] ?? "";
            minTransactionController.text = (data["minTransaction"] ?? 0).toString();
            endDate = DateTime.tryParse(data["endDate"] ?? "");
            uploadedImageName = data["image"]?.split("/").last ?? "";
          });
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Select End Date',
    );
    if (pickedDate != null) {
      setState(() => endDate = pickedDate);
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
                  date == null ? "Select date" : "${date.day}/${date.month}/${date.year}",
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
                      "Add New Voucher",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Title & Subtitle
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Title"),
                              const SizedBox(height: 6),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: "Enter voucher title",
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Subtitle"),
                              const SizedBox(height: 6),
                              TextField(
                                controller: subtitleController,
                                decoration: InputDecoration(
                                  hintText: "Enter voucher subtitle",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Min Transaction & End Date
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Min Transaction"),
                              const SizedBox(height: 6),
                              TextField(
                                controller: minTransactionController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter min transaction",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(child: dateBox("End Date", endDate, pickEndDate)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Obx(
                              () => voucherController.isLoading.value
                              ? const CircularProgressIndicator(color: kPrimaryGreen)
                              : ElevatedButton(
                            onPressed: () async {
                              if (titleController.text.isEmpty ||
                                  subtitleController.text.isEmpty ||
                                  minTransactionController.text.isEmpty ||
                                  endDate == null) {
                                Get.snackbar("Error", "Please fill all fields");
                                return;
                              }

                              final double? minTransaction =
                              double.tryParse(minTransactionController.text.trim());

                              if (minTransaction == null) {
                                Get.snackbar("Error", "Enter valid min transaction value");
                                return;
                              }

                              bool success;

                              if (widget.docId != null) {
                                // Update mode
                                success = await voucherController.updateVoucher(
                                  docId: widget.docId!,
                                  title: titleController.text.trim(),
                                  subtitle: subtitleController.text.trim(),
                                  minTransaction: minTransaction,
                                  endDate: endDate!,
                                );
                              } else {
                                // Add mode
                                success = await voucherController.addVoucher(
                                  title: titleController.text.trim(),
                                  subtitle: subtitleController.text.trim(),
                                  minTransaction: minTransaction,
                                  endDate: endDate!,
                                );
                              }

                              if (success) {
                                titleController.clear();
                                subtitleController.clear();
                                minTransactionController.clear();
                                setState(() => endDate = null);

                                if (context.mounted) {
                                  context.beamToNamed('/vouchers');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text("Save", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}




// import 'dart:typed_data';
// import 'package:beamer/beamer.dart';
// import 'package:coffee_shop_dashboard/controllers/VoucherController/voucherController.dart';
// import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
// import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../core/helpers/colors.dart';
// import '../../widgets/my_widgets/my_button.dart';
// import '../../widgets/my_widgets/my_text.dart';
//
// class AddVouhcernScreen extends StatefulWidget {
//   final String? docId;
//
//   const AddVouhcernScreen({super.key, this.docId});
//
//   @override
//   State<AddVouhcernScreen> createState() => _AddVoucherScreenState();
// }
//
// class _AddVoucherScreenState extends State<AddVouhcernScreen> {
//   final TextEditingController titleController1 = TextEditingController();
//   final TextEditingController titleController2 = TextEditingController();
//   final TextEditingController minTransactionController = TextEditingController();
//
//   final voucherController = Get.find<VoucherController>();
//
//   DateTime? endDate;
//
//   Uint8List? uploadedImageBytes;
//   String? uploadedImageName;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.docId != null) {
//       voucherController.getVoucherById(widget.docId!).then((data) {
//         if (data != null) {
//           setState(() {
//             titleController1.text = data["title"] ?? "";
//             titleController2.text = data["subtitle"] ?? "";
//             minTransactionController.text = data["minTransaction"]?.toString() ?? "";
//             endDate = DateTime.tryParse(data["endDate"] ?? "");
//             uploadedImageName = data["image"]?.split("/").last ?? "";
//           });
//         }
//       });
//     }
//   }
//
//   Future<void> pickEndDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: endDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       helpText: 'Select End Date',
//     );
//
//     if (pickedDate != null) {
//       setState(() => endDate = pickedDate);
//     }
//   }
//
//   Future<void> uploadImage() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );
//
//     if (result != null) {
//       setState(() {
//         uploadedImageBytes = result.files.single.bytes;
//         uploadedImageName = result.files.single.name;
//       });
//     }
//   }
//
//   Widget dateBox(String label, DateTime? date, VoidCallback onTap) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//         const SizedBox(height: 6),
//         InkWell(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Text(
//                   date == null ? "Select date" : "${date.day}/${date.month}/${date.year}",
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 const Spacer(),
//                 const Icon(Icons.calendar_today, size: 18, color: kPrimaryGreen),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: MyResponsive(builder: (_, __, type) {
//         return MyFlex(
//           contentPadding: true,
//           children: [
//             MyFlexItem(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Add New Voucher",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // ---------------- Row 1: Title + Min Transaction ----------------
//                   Row(
//                     children: [
//                       // Title
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Title"),
//                             const SizedBox(height: 6),
//                             TextField(
//                               controller: titleController1,
//                               decoration: InputDecoration(
//                                 hintText: "Enter voucher title",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(width: 30),
//
//                       // Min Transaction (replaces StartDate)
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Minimum Transaction"),
//                             const SizedBox(height: 6),
//                             TextField(
//                               controller: minTransactionController,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: "Enter minimum amount",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // ---------------- Row 2: Subtitle + End Date ----------------
//                   Row(
//                     children: [
//                       // Subtitle
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Subtitle"),
//                             const SizedBox(height: 6),
//                             TextField(
//                               controller: titleController2,
//                               decoration: InputDecoration(
//                                 hintText: "Enter subtitle",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(width: 30),
//
//                       // End Date
//                       Expanded(
//                         child: dateBox("End Date", endDate, pickEndDate),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 32),
//
//                   // ---------------- Image Upload Box ----------------
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 40),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1.4),
//                       color: Colors.grey.shade50,
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Upload Voucher Image",
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 6),
//                         const Text(
//                           "Drag and drop or browse to upload",
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: uploadImage,
//                           icon: const Icon(Icons.upload),
//                           label: const Text("Upload"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0B462D),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ),
//
//                         if (uploadedImageBytes != null) ...[
//                           const SizedBox(height: 20),
//                           Text("Selected: $uploadedImageName"),
//                         ]
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   // ---------------- Buttons ----------------
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("Cancel"),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//
//                       Obx(() => voucherController.isLoading.value
//                           ? CircularProgressIndicator(color: kPrimaryGreen)
//                           : MyButton.large(
//                         backgroundColor: kPrimaryGreen,
//                         onPressed: () async {
//                           if (titleController1.text.isEmpty ||
//                               titleController2.text.isEmpty ||
//                               minTransactionController.text.isEmpty ||
//                               endDate == null) {
//                             Get.snackbar("Error", "Please fill all fields");
//                             return;
//                           }
//
//                           final minAmount = double.tryParse(
//                               minTransactionController.text.trim());
//
//                           if (minAmount == null) {
//                             Get.snackbar("Invalid", "Minimum transaction must be a number");
//                             return;
//                           }
//
//                           bool success;
//
//                           if (widget.docId != null) {
//                             success = await voucherController.updateVoucher(
//                               docId: widget.docId!,
//                               title: titleController1.text.trim(),
//                               subtitle: titleController2.text.trim(),
//                               minTransaction: minAmount,
//                               endDate: endDate!,
//                             );
//                           } else {
//                             success = await voucherController.addVoucher(
//                               title: titleController1.text.trim(),
//                               subtitle: titleController2.text.trim(),
//                               minTransaction: minAmount,
//                               endDate: endDate!,
//                             );
//                           }
//
//                           if (success) {
//                             titleController1.clear();
//                             titleController2.clear();
//                             minTransactionController.clear();
//                             setState(() {
//                               endDate = null;
//                               uploadedImageBytes = null;
//                               uploadedImageName = null;
//                             });
//
//                             if (context.mounted) {
//                               context.beamToNamed('/vouchers');
//                             }
//                           }
//                         },
//                         child: Center(
//                           child: MyText.bodyLarge(
//                             widget.docId != null ? 'Update' : 'Create',
//                             color: Colors.white,
//                           ),
//                         ),
//                       )),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
//
//
//
