import 'dart:convert';
import 'package:Prontas/component/bannerlist.dart';
import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/buttons/itembuttom.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/account/account.dart';
import 'package:Prontas/view/account/auth/signup.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:Prontas/model/carrouselbanners.dart';

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
  final liveRandomText =
      TextEditingController(text: Random().nextInt(10000).toString());

  final liveText = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: RemoteAuthService()
          .getProfile(token: token.toString()), // Chamada assíncrona
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ); // Mostra um indicador de carregamento
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Aqui já temos certeza de que snapshot.data não é nulo
        var userData = jsonDecode(snapshot.data!.body);
        var planId = userData["planid"];

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

        return token == null
            ? const SizedBox()
            : SafeArea(
                child: SizedBox(
                  child: ListView(
                    children: [
                      Padding(
                        padding: defaultPaddingHorizon,
                        child: MainHeader(
                          title: "Prontas",
                          icon: Icons.menu,
                          onClick: () => _showDraggableScrollableSheet(context),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 800;
                        return Center(
                          child: SizedBox(
                            width: isDesktop ? 600 : double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Campo de entrada com validação
                                Padding(
                                  padding: defaultPadding,
                                  child: Column(
                                    children: [
                                      SecundaryText(
                                        text:
                                            "Digite o código do parto que deseja assistir",
                                        color: nightColor,
                                        align: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      InputTextField(
                                        textEditingController: liveText,
                                        title: "",
                                        fcolor: nightColor,
                                        fill: true,
                                        // textInputType: TextInputType.number,
                                        // inputFormatters: [
                                        //   FilteringTextInputFormatter
                                        //       .digitsOnly, // Apenas números
                                        //   LengthLimitingTextInputFormatter(
                                        //     13,
                                        //   ), // Limitar a 13 caracteres
                                        // ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Builder(builder: (context) {
                                        return GestureDetector(
                                          onTap: () => jumpToLivePage(
                                            liveRandomText: liveText.text,
                                            context,
                                            liveID: liveText.text,
                                            isHost: false,
                                          ),
                                          child: DefaultButton(
                                            text: "Acessar",
                                            padding: defaultPadding,
                                            icon: Icons
                                                .keyboard_arrow_right_outlined,
                                            color: SecudaryColor,
                                            colorText: lightColor,
                                            // Desabilita o botão se o CPF for menor que 11 caracteres
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 50,
                                ),

                                // Caroulsel --------------

                                FutureBuilder<List<Banners>>(
                                  future: RemoteAuthService()
                                      .getCarrouselBanners(
                                          token: token, id: "1"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const SizedBox(
                                          height: 50,
                                          child: Center(child: SizedBox()),
                                        );
                                      } else {
                                        return CarouselSlider.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            var renders = snapshot.data![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: BannerList(
                                                imageUrl:
                                                    renders.urlimage.toString(),
                                                redirectUrl:
                                                    renders.urlroute.toString(),
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                            height: (320 * 9) / 16,
                                            autoPlay:
                                                true, // Habilita o deslizamento automático
                                            autoPlayInterval: const Duration(
                                                seconds: 3), // Intervalo
                                            enlargeCenterPage:
                                                true, // Destaque do item central
                                            viewportFraction:
                                                0.7, // Proporção dos itens visíveis
                                          ),
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return const Center(child: SizedBox());
                                    }
                                    return SizedBox(
                                      height: 150,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      if (planId == 2)
                        Padding(
                          padding: defaultPadding,
                          child: Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: () => jumpToLivePage(
                                    liveRandomText: liveRandomText.text,
                                    context,
                                    liveID: liveRandomText.text,
                                    isHost: true,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ItemButtom(icon: Icons.circle_outlined),
                                      SubText(
                                        text: "Iniciar a transmissão do parto.",
                                        align: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: defaultPadding,
                                child: RichDefaultText(
                                  text: 'Precisa de uma conta? ',
                                  size: 12,
                                  wid: GestureDetector(
                                    onTap: () {
                                      (
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SubText(
                                      text: 'Crie uma aqui!',
                                      align: TextAlign.start,
                                      color: PrimaryColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      else
                        SizedBox(),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ); // Exemplo de exibição do ID
      },
    );
  }

  jumpToLivePage(BuildContext context,
      {required String liveID,
      required bool isHost,
      required String liveRandomText}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LivePage(
                id: id.toString(),
                codlive: liveRandomText,
                liveID: liveID,
                isHost: isHost,
                username: username.toString(),
              )),
    );
  }
}
