import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/controller/auth.dart';
import 'package:Prontas/view/account/account.dart';
import 'package:Prontas/view/spector/spectorscreen.dart';
import 'package:Prontas/view/videocall/videocall.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var client = http.Client();

  String screen = "online";
  bool isButtonEnabled = false;

  String? token;
  String? fname;
  String? fullname;
  String? colaboratorId;

  var id;
  bool public = false;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken("token");
    var strFullname = await LocalAuthService().getFullName("fullname");
    var strcolaboratorId =
        await LocalAuthService().getColaboratorId("colaboratorId");

    // var strCpf = await LocalAuthService().getCpf("cpf");

    // Verifique se o widget ainda está montado antes de chamar setState
    if (mounted) {
      setState(() {
        // Caso strCpf seja null, passamos uma string vazia
        // cpf.text = strCpf ?? ''; // Usa uma string vazia se strCpf for null
        token = strToken;
        fullname = strFullname;
        colaboratorId = strcolaboratorId;
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

  void _showDraggableScrollableSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
                color: Colors.white,
                child: Padding(
                  padding: defaultPadding,
                  child: ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: SecudaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            (Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountScreen(
                                        buttom: true,
                                      )),
                            ));
                          },
                          child: Padding(
                            padding: defaultPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    SubText(
                                      text: 'Meu Perfil',
                                      align: TextAlign.start,
                                      color: nightColor,
                                    ),
                                    SubTextSized(
                                      text:
                                          'Verificar informações e sair da conta',
                                      size: 10,
                                      fontweight: FontWeight.w600,
                                      color: OffColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

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
                        onClick: () => _showDraggableScrollableSheet(context)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              (Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoCall()),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundColor: PrimaryColor,
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.add),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: SubText(
                                        text: "Iniciar Transmissão",
                                        align: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              (Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpectorScreen()),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundColor: SecudaryColor,
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.person),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: SubText(
                                        text: "Paula Matos ",
                                        align: TextAlign.center),
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
                  Padding(
                    padding: defaultPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Campo de entrada com validação
                        InputTextField(
                          textEditingController: cpf,
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
                            onTap: () {
                              print(cpf.text);
                              AuthController().requests(
                                cpf: cpf.text,
                                colaboratorId: colaboratorId.toString(),
                                fullname: fullname.toString(),
                                resultReq: "Teste",
                              );
                            },
                            child: GestureDetector(
                              onTap: isButtonEnabled
                                  ? () {
                                      print(cpf.text);
                                      AuthController().requests(
                                        cpf: cpf.text,
                                        colaboratorId: colaboratorId.toString(),
                                        fullname: fullname.toString(),
                                        resultReq: "Teste",
                                      );
                                    }
                                  : null,
                              child: DefaultButton(
                                text: "Acessar",
                                padding: defaultPadding,
                                icon: Icons.keyboard_arrow_right_outlined,
                                color: SecudaryColor,
                                colorText: nightColor,
                                // Desabilita o botão se o CPF for menor que 11 caracteres
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}