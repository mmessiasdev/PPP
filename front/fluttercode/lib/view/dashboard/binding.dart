import 'package:get/get.dart';
import 'package:Prontas/controller/auth.dart';
import 'package:Prontas/controller/dashboard.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(AuthController());
  }
}