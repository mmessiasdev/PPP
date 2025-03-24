import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/defaultButton.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/controller/auth.dart';
import 'package:Prontas/view/account/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool checked = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // List<Widget> get _pages => [
  //       InputLogin(
  //         title: "Email ou CPF",
  //         controller: emailController,
  //         keyboardType: TextInputType.emailAddress,
  //       ),
  //       InputLogin(
  //         title: "Senha",
  //         controller: passwordController,
  //         obsecureText: true,
  //       ),
  //     ];

  // void _previousPage() {
  //   if (_currentPage > 0) {
  //     _pageController.previousPage(
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizon,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 95,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/logo/image.png",
                              width: 80,
                            ),
                            PrimaryText(
                              color: nightColor,
                              text: "Faça login",
                            )
                          ],
                        ),
                        SizedBox(
                          height: 95,
                        ),
                        Column(
                          children: [
                            InputLogin(
                              title: "Email ou CPF",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            InputLogin(
                              title: "Senha",
                              controller: passwordController,
                              obsecureText: true,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 95,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  authController.signIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultButton(
                                    text: "Entrar",
                                    color: PrimaryColor,
                                    colorText: lightColor,
                                    padding: defaultPadding,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     (
                            //       Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => SignUpScreen(
                            //             backButtom: true,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       DefaultButton(
                            //         text: "Criar conta",
                            //         color: SecudaryColor,
                            //         colorText: lightColor,
                            //         padding: defaultPadding,
                            //       ),
                            //       SizedBox(
                            //         height: 20,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class InputLogin extends StatelessWidget {
  InputLogin(
      {super.key,
      this.title,
      this.inputTitle,
      required this.controller,
      this.keyboardType,
      this.obsecureText});

  String? title;
  String? inputTitle;

  TextEditingController controller;
  bool? obsecureText;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPaddingHorizonTop,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubText(
            color: nightColor,
            text: title ?? "",
            align: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
          InputTextField(
            obsecureText: obsecureText ?? false,
            textEditingController: controller,
            textInputType: keyboardType ?? TextInputType.text,
            title: inputTitle ?? "",
            fill: true,
            maxLines: 1, // Define maxLines para 1
          ),
        ],
      ),
    );
  }
}
