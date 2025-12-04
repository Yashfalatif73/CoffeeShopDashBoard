import 'package:coffee_shop_dashboard/controllers/VoucherController/voucherController.dart';
import 'package:coffee_shop_dashboard/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/base_controller/my_controller.dart';
import '../controllers/campaign_controller/campaignControllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(CampaignsFirebaseController(), permanent: true);
    Get.put(VoucherController(), permanent: true);
  }
}