import 'package:Prontas/component/padding.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/view/account/account.dart';
import 'package:Prontas/view/account/auth/signin.dart';
import 'package:Prontas/view/club/home/homepage.dart';
import 'package:Prontas/view/course/homepage.dart';
import 'package:Prontas/view/freeplaylist/home/homepage.dart';
import 'package:Prontas/view/live/homepage.dart';
import 'package:Prontas/view/prenatalwallet/homescreen.dart';
import 'package:Prontas/view/prenatalwallet/timelineprenatal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:Prontas/view/home/homepage.dart';
import 'package:get/get.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/controller/dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var token;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();

    setState(() {
      token = strToken.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: GetBuilder<DashboardController>(
      builder: (controller) => token == "null"
          ? SignInScreen()
          : Scaffold(
              backgroundColor: lightColor,
              body: SafeArea(
                child: IndexedStack(
                  index: controller.tabIndex,
                  children: [HomePage(), CoursesHomePage(), LiveHomePage()],
                ),
              ),
              bottomNavigationBar: SnakeNavigationBar.color(
                snakeShape: SnakeShape.rectangle,
                backgroundColor: PrimaryColor,
                unselectedItemColor: lightColor,
                showUnselectedLabels: true,
                selectedItemColor: lightColor,
                snakeViewColor: SecudaryColor,
                currentIndex: controller.tabIndex,
                onTap: (val) {
                  controller.updateIndex(val);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                    Icons.home,
                    size: 30,
                  )),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.trip_origin,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
    ));
  }
}
