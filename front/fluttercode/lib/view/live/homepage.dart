import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/view/account/account.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:Prontas/view/live/livepage.dart';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class LiveHomePage extends StatefulWidget {
  const LiveHomePage({super.key});

  @override
  State<LiveHomePage> createState() => _LiveHomePageState();
}

class _LiveHomePageState extends State<LiveHomePage> {
  var client = http.Client();

  String screen = "online";
  bool isButtonEnabled = false;

  String? token;
  String? fname;
  String? fullname;
  String? username;
  String? id;

  bool public = false;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strFullname = await LocalAuthService().getFullName();
    var strUserId = await LocalAuthService().getId();

    var strUsername = await LocalAuthService().getUsername();

    // Verifique se o widget ainda está montado antes de chamar setState
    if (mounted) {
      setState(() {
        // Caso strCpf seja null, passamos uma string vazia
        // cpf.text = strCpf ?? ''; // Usa uma string vazia se strCpf for null
        token = strToken;
        fullname = strFullname;
        username = strUsername;
        id = strUserId;
      });
    }
  }

  TextEditingController cpf = TextEditingController();

  @override
  void dispose() {
    cpf.dispose();
    super.dispose();
  }

  Widget ManutentionErro() {
    return ErrorPost(
      text: "Estamos passando por uma manutenção. Entre novamente mais tarde!",
    );
  }

  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const SizedBox()
        : SafeArea(
            child: SizedBox(
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizon,
                    child: MainHeader(
                      title: "Prontas Pra Parir!",
                      icon: Icons.menu,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: defaultPadding,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 800;
                      return Center(
                        child: SizedBox(
                          width: isDesktop ? 600 : double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Campo de entrada com validação

                              InputTextField(
                                textEditingController: liveTextCtrl,
                                title:
                                    "Digite aqui o link do parto que deseja assistir!",
                                fcolor: nightColor,
                                fill: true,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Apenas números
                                  LengthLimitingTextInputFormatter(
                                    13,
                                  ), // Limitar a 13 caracteres
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Builder(builder: (context) {
                                return GestureDetector(
                                  onTap: () => jumpToLivePage(
                                    liveTextCtrl: liveTextCtrl.text,
                                    context,
                                    liveID: liveTextCtrl.text,
                                    isHost: false,
                                  ),
                                  child: DefaultButton(
                                    text: "Acessar",
                                    padding: defaultPadding,
                                    icon: Icons.keyboard_arrow_right_outlined,
                                    color: PrimaryColor,
                                    colorText: lightColor,
                                    // Desabilita o botão se o CPF for menor que 11 caracteres
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => jumpToLivePage(
                              liveTextCtrl: liveTextCtrl.text,
                              context,
                              liveID: liveTextCtrl.text,
                              isHost: true,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundColor: PrimaryColor,
                                      child: const CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.add),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(username.toString()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: SubText(
                                      text: "Iniciar Transmissão",
                                      align: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          );
  }

  jumpToLivePage(BuildContext context,
      {required String liveID,
      required bool isHost,
      required String liveTextCtrl}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LivePage(
                id: id.toString(),
                codlive: liveTextCtrl,
                liveID: liveID,
                isHost: isHost,
                username: username.toString(),
              )),
    );
  }
}
