import 'package:Prontas/component/bannerlist.dart';
import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/buttons/itembuttom.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/account/account.dart';
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
                      title: "Prontas",
                      icon: Icons.menu,
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
                                          "Digite o código do parto qe deseja assistir",
                                      color: nightColor,
                                      align: TextAlign.center),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  InputTextField(
                                    textEditingController: liveTextCtrl,
                                    title: "",
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
                                  SizedBox(
                                    height: 30,
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
                                        icon:
                                            Icons.keyboard_arrow_right_outlined,
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
                                  .getCarrouselBanners(token: token, id: "1"),
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
                                      itemBuilder: (context, index, realIndex) {
                                        var renders = snapshot.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
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
                  Padding(
                    padding: defaultPadding,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => jumpToLivePage(
                          liveTextCtrl: liveTextCtrl.text,
                          context,
                          liveID: liveTextCtrl.text,
                          isHost: true,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
