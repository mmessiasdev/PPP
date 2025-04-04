import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/widgets/infotext.dart';
import 'package:Prontas/component/widgets/title.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/controller/controllers.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../../component/defaultTitleButtom.dart';
import '../../component/colors.dart';
import 'auth/signin.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key, required this.buttom}) : super(key: key);
  bool buttom;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var email;
  var fullname;
  var cpf;
  var id;
  var token;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strEmail = await LocalAuthService().getEmail();
    var strFullname = await LocalAuthService().getFullName();
    var strId = await LocalAuthService().getId();
    var strToken = await LocalAuthService().getSecureToken();

    if (mounted) {
      setState(() {
        email = strEmail.toString();
        fullname = strFullname.toString();
        id = strId.toString();
        token = strToken.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightColor,
      child: ListView(
        children: [
          MainHeader(
              title: "Prontas",
              icon: Icons.arrow_back_ios,
              onClick: () => Navigator.of(Get.overlayContext!).pop()),
          Padding(
            padding: defaultPadding,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InfoText(
                  title: "Nome:",
                  stitle: fullname == "null" ? "" : fullname,
                  icon: Icons.people,
                ),
                SizedBox(
                  height: 20,
                ),
                InfoText(
                  title: "Email:",
                  stitle: email == "null" ? "" : email,
                  icon: Icons.email,
                ),
                SizedBox(
                  height: 20,
                ),
                // InfoText(title: "Username:", stitle: cpf == "null" ? "" : cpf),
                SizedBox(
                  height: 70,
                ),
                DefaultTitleButton(
                  title: email == "null" ? "Entrar na conta" : "Sair da conta",
                  onClick: () {
                    if (token != "null") {
                      authController.signOut(context);
                      // Navigator.pop(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SignInScreen(),
                      //   ),
                      // );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    }
                  },
                  color: FifthColor,
                  iconColor: nightColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
