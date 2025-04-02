import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/widgets/title.dart';
import 'package:Prontas/controller/controllers.dart';
import 'package:Prontas/view/account/auth/signin.dart';
import 'package:Prontas/view/dashboard/screen.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key, required this.backButtom}) : super(key: key);
  bool backButtom;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: LayoutBuilder(builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;
        return Center(
          child: SizedBox(
            width: isDesktop ? 600 : double.infinity,
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: defaultPadding,
                      child: DefaultTitle(
                        buttom: widget.backButtom ?? false,
                        title: "Crie sua conta!",
                        subtitle: "Para desfrutar de todos benefícios ",
                        subbuttom: SubTextSized(
                          align: TextAlign.start,
                          fontweight: FontWeight.w600,
                          text: "que preparamos pra você!",
                          size: 20,
                          color: nightColor,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        InputLogin(
                          inputTitle: 'Username',
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                        ),
                        InputLogin(
                          inputTitle: 'Nome Completo',
                          controller: fullnameController,
                          keyboardType: TextInputType.text,
                        ),
                        InputLogin(
                          inputTitle: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        InputLogin(
                          inputTitle: 'Senha',
                          controller: passwordController,
                          obsecureText: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                authController.signUp(
                                    fullname: fullnameController.text,
                                    email: emailController.text,
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    adminScreen: true);
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultButton(
                                  text: "Criar cadastro",
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
                          //     child: RichDefaultText(
                          //         wid: GestureDetector(
                          //           onTap: () {
                          //             (
                          //               Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const DashboardScreen(),
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //           child: GestureDetector(
                          //             onTap: () {
                          //               (Navigator.pushReplacement(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         DashboardScreen(),
                          //                   )));
                          //             },
                          //             child: SubTextSized(
                          //               align: TextAlign.start,
                          //               color: SecudaryColor,
                          //               size: 16,
                          //               text: "Entre",
                          //               fontweight: FontWeight.w600,
                          //             ),
                          //           ),
                          //         ),
                          //         text: "Já tem um login? ",
                          //         align: TextAlign.start,
                          //         size: 16,
                          //         fontweight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
