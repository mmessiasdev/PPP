import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/widgets/title.dart';
import 'package:Prontas/controller/controllers.dart';
import 'package:Prontas/view/account/auth/signin.dart';
import 'package:Prontas/view/dashboard/screen.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: defaultPaddingHorizon,
                child: DefaultTitle(
                  buttom: false,
                  title: "Crie sua conta!",
                  subtitle: "Para desfrutar de todos benefícios ",
                  subbuttom: SubTextSized(
                    align: TextAlign.start,
                    fontweight: FontWeight.w600,
                    text: "que preparamos pra você!.",
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
                    keyboardType: TextInputType.number,
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
                padding: defaultPaddingHorizon,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: RichDefaultText(
                            wid: GestureDetector(
                              onTap: () {
                                (
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  (Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardScreen(),
                                      )));
                                },
                                child: SubTextSized(
                                  align: TextAlign.start,
                                  color: FourtyColor,
                                  size: 16,
                                  text: "Entre",
                                  fontweight: FontWeight.w600,
                                ),
                              ),
                            ),
                            text: "Já tem um login? ",
                            align: TextAlign.start,
                            size: 16,
                            fontweight: FontWeight.normal)),
                    const SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      maxRadius: 40,
                      backgroundColor: FourtyColor,
                      child: GestureDetector(
                        child: Icon(
                          Icons.arrow_right_alt,
                          color: lightColor,
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            authController.signUp(
                              fullname: fullnameController.text,
                              email: emailController.text,
                              username: usernameController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
