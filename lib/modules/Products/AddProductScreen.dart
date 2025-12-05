import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/controllers/product_controller.dart';
import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/MyTextField.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_button.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/helpers/colors.dart';
import '../../widgets/my_widgets/my_text.dart';

class AddProductScreen extends StatefulWidget {
  final VoidCallback? onCancel;

  const AddProductScreen({super.key, this.onCancel});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final controller = Get.put(ProductController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Ensure form is cleared when screen loads
    controller.clearForm();
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      MyText(
                        "Add New Product",
                        fontSize: 20,
                        fontWeight: 700,
                      ),

                      const SizedBox(height: 20),

                      // Scrollable area
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PRODUCT NAME + PRICE
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      text: "Name *",
                                      hintText: "Enter product name",
                                      controller: controller.nameController,
                                      keyboardType: TextInputType.text
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  Expanded(
                                    child: MyTextField(
                                      text: "Price *",
                                      hintText: "Enter price",
                                      controller: controller.priceController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true)
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // QUANTITY
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      text: "Quantity (In Stock) *",
                                      hintText: "Enter quantity",
                                      controller: controller.quantityController,
                                      keyboardType: TextInputType.number
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  const Expanded(child: SizedBox()), // Empty space for alignment
                                ],
                              ),

                              // CATEGORY + SUB CATEGORY
                              Row(
                                children: [
                                  Expanded(
                                    child: Obx(() => _dropdown(
                                        label: "Category *",
                                        value: controller.selectedCategory.value,
                                        items: controller.categories,
                                        onChanged: (value){
                                          if(value != null){
                                            controller.selectedCategory.value = value;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  Expanded(
                                    child: Obx(() {
                                      final category = controller.selectedCategory.value;
                                      if(category.isNotEmpty && category == "Coffee"){
                                        return _dropdown(
                                          label: "Sub Category",
                                          value: controller.selectedSubCategory.value,
                                          items: controller.subCategories,
                                          onChanged: (value){
                                            if(value != null){
                                              controller.selectedSubCategory.value = value;
                                            }
                                          },
                                        );
                                      }
                                      return const SizedBox.shrink();
                                      }
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // AVAILABLE IN + SIZE (Coffee only)
                              Obx(() {
                                final category = controller.selectedCategory.value;
                                if(category.isNotEmpty && category == "Coffee"){
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _dropdown(
                                          label: "Available In",
                                          value: controller.selectedAvailable.value,
                                          items: controller.availableIn,
                                          onChanged: (v){
                                            if(v != null){
                                              controller.selectedAvailable.value = v;
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 22),
                                      Expanded(
                                        child: _dropdown(
                                          label: "Size",
                                          value: controller.selectedSize.value,
                                          items: controller.sizes,
                                          onChanged: (v){
                                            if(v != null){
                                              controller.selectedSize.value = v;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                                }
                              ),

                              const SizedBox(height: 24),

                              // IMAGE PLACEHOLDER NOTE
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE2E2E2)),
                                  color: kLightGreen.withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: kPrimaryGreen),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        "Product image will use a default coffee placeholder. Firebase Storage integration coming soon!",
                                        fontSize: 13,
                                        color: kPrimaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 26),

                              // ACTION BUTTONS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MyButton.rounded(
                                    onPressed: (){
                                      controller.clearForm();
                                      if(context.canBeamBack){
                                        context.beamBack();
                                      }else{
                                        context.beamToReplacementNamed("/products", popBeamLocationOnPop: true);
                                      }
                                    },
                                    backgroundColor: colorWhite,
                                    child: MyText("Cancel", fontWeight: 600),
                                  ),

                                  const SizedBox(width: 16),

                                  Obx(() => controller.isLoading.value
                                      ? const CircularProgressIndicator(color: kPrimaryGreen)
                                      : MyButton.rounded(
                                          onPressed: () async {
                                            if(formKey.currentState!.validate()){
                                              await controller.addProduct(
                                                context: context,
                                                name: controller.nameController.text,
                                                price: controller.priceController.text,
                                                category: controller.selectedCategory.value,
                                                quantity: controller.quantityController.text,
                                                subCategory: controller.selectedSubCategory.value,
                                                availableIn: controller.selectedAvailable.value,
                                                size: controller.selectedSize.value,
                                              ).then((success){
                                                if (success) {
                                                  controller.clearForm();
                                                  if (context.mounted) {
                                                    context.beamToNamed('/products');
                                                  }
                                                }
                                              });
                                            }
                                          },
                                          child: MyText("  Add Product  ", fontWeight: 600, color: colorWhite),
                                        ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _dropdown({
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
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
