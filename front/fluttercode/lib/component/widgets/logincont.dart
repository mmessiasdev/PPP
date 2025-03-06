import 'package:Prontas/component/defaultTitleButtom.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/inputlight.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/title.dart';
import 'package:Prontas/controller/controllers.dart';
import 'package:Prontas/extention/string_extention.dart';
import 'package:Prontas/view/account/auth/signup.dart';
import 'package:flutter/material.dart';

class LoginContent extends StatefulWidget {
  LoginContent({super.key, this.title});
  bool? title = true;

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title == true
              ? DefaultTitle(
                  title: "Faça login!",
                  subtitle: "Compartilhe seus momentos com seus amigos ou ",
                  subbuttom: SubTextSized(
                    align: TextAlign.start,
                    fontweight: FontWeight.w600,
                    text: "com você mesmo!",
                    size: 20,
                    color: nightColor,
                  ),
                )
              : SizedBox(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputTextField(
                  title: 'Email',
                  fill: true,
                  textEditingController: emailController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Esse campo não pode ficar vazio.";
                    } else if (!value.isValidEmail) {
                      return "Insira um email válido.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InputTextField(
                  title: 'Password',
                  obsecureText: true,
                  fill: true,
                  maxLines: 1,
                  // icon: Icon(Icons.lock),
                  textEditingController: passwordController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Esse campo não pode ficar vazio.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Row(
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
                                      builder: (context) => SignUpScreen(
                                        backButtom: false,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: SubTextSized(
                                align: TextAlign.start,
                                color: FourtyColor,
                                size: 16,
                                text: "Crie uma conta.",
                                fontweight: FontWeight.w600,
                                tdeco: TextDecoration.underline,
                              ),
                            ),
                            text: "Não tem login? ",
                            align: TextAlign.start,
                            size: 16,
                            fontweight: FontWeight.normal)),
                    SizedBox(
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
                            // authController.signIn(
                            //   email: emailController.text,
                            //   password: passwordController.text,
                            // );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
