import 'package:Prontas/route/route.dart';
import 'package:Prontas/view/account/auth/signin.dart';
import 'package:Prontas/view/dashboard/binding.dart';
import 'package:Prontas/view/dashboard/screen.dart';
import 'package:get/get.dart';

class AppPage {
  static var list = [
    GetPage(
      name: AppRoute.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoute.loginIn,
      page: () => const SignInScreen(),
    ),
  ];
}
