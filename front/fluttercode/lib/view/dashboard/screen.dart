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
      child: SizedBox(
          child: GetBuilder<DashboardController>(
        builder: (controller) => token == "null"
            ? SignInScreen()
            : Scaffold(
                backgroundColor: lightColor,
                body: SafeArea(
                  child: IndexedStack(
                    index: controller.tabIndex,
                    children: [
                      HomePage(),
                      HomePageClub(),
                      HomePageCoursesScreen(),
                      PlaylistsHomePage(),
                      PreNatalScreen(),
                      PrenatalTimelineScreen(),
                      LiveHomePage()
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: lightColor,
                  ),
                  child: SnakeNavigationBar.color(
                    snakeShape: SnakeShape.rectangle,
                    backgroundColor: PrimaryColor,
                    unselectedItemColor: nightColor,
                    showUnselectedLabels: true,
                    selectedItemColor: nightColor,
                    snakeViewColor: SecudaryColor,
                    currentIndex: controller.tabIndex,
                    onTap: (val) {
                      controller.updateIndex(val);
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(
                        Icons.video_call,
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
                          Icons.play_arrow,
                          size: 30,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.search_sharp,
                          size: 30,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.bedroom_baby,
                          size: 30,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.timelapse,
                          size: 30,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.circle,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
