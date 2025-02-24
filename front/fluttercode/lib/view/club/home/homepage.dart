import 'dart:convert';

import 'package:Prontas/component/bannerlist.dart';
import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/contentproduct.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/widgets/iconlist.dart';
import 'package:Prontas/component/widgets/title.dart';
import 'package:Prontas/model/carrouselbanners.dart';
import 'package:Prontas/model/categoriesclub.dart';
import 'package:Prontas/model/localstores.dart';
import 'package:Prontas/model/stores.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/club/category/categoryscreen.dart';
import 'package:Prontas/view/club/qrcode/qrcodescreen.dart';
import 'package:Prontas/view/club/store/local/localstorelist.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:http/http.dart' as http;

import '../../../component/widgets/listtitle.dart';

class HomePageClub extends StatefulWidget {
  const HomePageClub({super.key});

  @override
  State<HomePageClub> createState() => _HomePageClubState();
}

class _HomePageClubState extends State<HomePageClub> {
  var client = http.Client();

  String screen = "online";

  String? token;
  String? fname;
  var id;
  bool public = false;
  var idPlan;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();

    // Verifique se o widget ainda está montado antes de chamar setState
    if (mounted) {
      setState(() {
        token = strToken;
      });
    }
  }

  TextEditingController content = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  void dispose() {
    content.dispose();
    title.dispose();
    desc.dispose();
    super.dispose();
  }

  void toggleIcon() {
    setState(() {
      public = !public; // Alterna entre os ícones
    });
  }

  Widget ManutentionErro() {
    return ErrorPost(
      text: "Estamos passando por uma manutenção. Entre novamente mais tarde!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const SizedBox()
        : LayoutBuilder(builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;

            return SafeArea(
              child: Scaffold(
                backgroundColor: lightColor,
                body: FutureBuilder(
                    future:
                        RemoteAuthService().getProfile(token: token.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const WidgetLoading();
                      } else if (snapshot.hasData) {
                        var response = snapshot.data as http.Response;
                        // Verifica se o status da resposta é 200 (OK)
                        if (response.statusCode == 200) {
                          // Verifica se o conteúdo da resposta é JSON
                          try {
                            var render = jsonDecode(response.body)
                                as Map<String, dynamic>;

                            // Verifica se o campo "plan" é nulo
                            if (render != null && render['plan'] == null) {
                              return SizedBox(
                                child: Center(
                                    child:
                                        Text('Você não possui nenhum plano')),
                              );
                            } else {
                              idPlan = render['plan']['id'].toString();
                              return ListView(
                                children: [
                                  Padding(
                                    padding: defaultPaddingHorizon,
                                    child: MainHeader(
                                      title: "Prontas",
                                      icon: Icons.arrow_back_ios,
                                      onClick: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: defaultPaddingHorizon,
                                  //   child: const SearchClubInput(),
                                  // ),
                                  const SizedBox(
                                    height: 45,
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: defaultPaddingHorizon,
                                        child: const ListTitle(
                                            title: "Cashback em lojas!"),
                                      ),
                                      SizedBox(
                                        height:
                                            250, // Altura definida para o ListView
                                        child: FutureBuilder<List<StoresModel>>(
                                          future: RemoteAuthService()
                                              .getStores(token: token),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData) {
                                              if (snapshot.data!.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                      "Nenhuma loja disponível no momento."),
                                                );
                                              } else {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var renders =
                                                        snapshot.data![index];
                                                    return ContentProduct(
                                                      urlThumb: renders.logourl
                                                          .toString(),
                                                      drules:
                                                          "${renders.percentcashback}% de cashback",
                                                      title: renders.name
                                                          .toString(),
                                                      id: renders.id.toString(),
                                                    );
                                                  },
                                                );
                                              }
                                            } else if (snapshot.hasError) {
                                              return WidgetLoading();
                                            }
                                            return SizedBox(
                                              height: 300,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: nightColor,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       defaultPaddingHorizon,
                                      //   child: const ListTitle(
                                      //       title: "Lojas locais"),
                                      // ),
                                      // FutureBuilder<
                                      //     List<LocalStores>>(
                                      //   future: RemoteAuthService()
                                      //       .getLocalStores(
                                      //           token: token),
                                      //   builder: (context, snapshot) {
                                      //     if (snapshot.connectionState ==
                                      //             ConnectionState
                                      //                 .done &&
                                      //         snapshot.hasData) {
                                      //       if (snapshot
                                      //           .data!.isEmpty) {
                                      //         return const SizedBox(
                                      //           height: 200,
                                      //           child: Center(
                                      //             child: Text(
                                      //                 "Nenhuma loja disponível no momento."),
                                      //           ),
                                      //         );
                                      //       } else {
                                      //         return ListView.builder(
                                      //           shrinkWrap: true,
                                      //           physics:
                                      //               const NeverScrollableScrollPhysics(),
                                      //           itemCount: snapshot
                                      //               .data!.length,
                                      //           itemBuilder:
                                      //               (context, index) {
                                      //             var renders =
                                      //                 snapshot.data![
                                      //                     index];
                                      //             print(renders
                                      //                 .benefit);
                                      //             // Verificação se o idPlan não é nulo
                                      //             return Padding(
                                      //               padding:
                                      //                   defaultPadding,
                                      //               child:
                                      //                   ContentLocalProduct(
                                      //                 urlLogo: renders
                                      //                     .urllogo
                                      //                     .toString(),
                                      //                 benefit: renders
                                      //                     .benefit
                                      //                     .toString(),
                                      //                 title: renders
                                      //                     .name
                                      //                     .toString(),
                                      //                 id: renders.id
                                      //                     .toString(),
                                      //               ),
                                      //             );
                                      //           },
                                      //         );
                                      //       }
                                      //     } else if (snapshot
                                      //         .hasError) {
                                      //       return WidgetLoading();
                                      //     }
                                      //     return SizedBox(
                                      //       height: 300,
                                      //       child: Center(
                                      //         child:
                                      //             CircularProgressIndicator(
                                      //           color: nightColor,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      // Padding(
                                      //   padding: defaultPadding,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               LocalStoreListScreen(),
                                      //         ),
                                      //       );
                                      //     },
                                      //     child: SubTextSized(
                                      //       text: "Ver mais",
                                      //       align: TextAlign.center,
                                      //       fontweight:
                                      //           FontWeight.w600,
                                      //       size: 12,
                                      //       tdeco: TextDecoration
                                      //           .underline,
                                      //     ),
                                      //   ),
                                      // ),

                                      // Padding(
                                      //   padding:
                                      //       defaultPaddingHorizon,
                                      //   child: const ListTitle(
                                      //       title: "Eletrônicos"),
                                      // ),
                                      // SizedBox(
                                      //   height:
                                      //       250, // Altura definida para o ListView
                                      //   child: FutureBuilder<
                                      //       List<OnlineStores>>(
                                      //     future: RemoteAuthService()
                                      //         .getOneCategoryStories(
                                      //             token: token,
                                      //             id: '2'),
                                      //     builder:
                                      //         (context, snapshot) {
                                      //       if (snapshot.connectionState ==
                                      //               ConnectionState
                                      //                   .done &&
                                      //           snapshot.hasData) {
                                      //         if (snapshot
                                      //             .data!.isEmpty) {
                                      //           return const Center(
                                      //             child: Text(
                                      //                 "Nenhuma loja disponível no momento."),
                                      //           );
                                      //         } else {
                                      //           return ListView
                                      //               .builder(
                                      //             shrinkWrap: true,
                                      //             scrollDirection:
                                      //                 Axis.horizontal,
                                      //             physics:
                                      //                 const NeverScrollableScrollPhysics(),
                                      //             itemCount: snapshot
                                      //                 .data!.length,
                                      //             itemBuilder:
                                      //                 (context,
                                      //                     index) {
                                      //               var renders =
                                      //                   snapshot.data![
                                      //                       index];
                                      //               return ContentProduct(
                                      //                 urlLogo: renders
                                      //                     .logourl
                                      //                     .toString(),
                                      //                 drules:
                                      //                     "${renders.percentcashback}% de cashback",
                                      //                 title: renders
                                      //                     .name
                                      //                     .toString(),
                                      //                 id: renders.id
                                      //                     .toString(),
                                      //               );
                                      //             },
                                      //           );
                                      //         }
                                      //       } else if (snapshot
                                      //           .hasError) {
                                      //         return WidgetLoading();
                                      //       }
                                      //       return SizedBox(
                                      //         height: 300,
                                      //         child: Center(
                                      //           child:
                                      //               CircularProgressIndicator(
                                      //             color: nightColor,
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
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
                                              var renders =
                                                  snapshot.data![index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: BannerList(
                                                  imageUrl: renders.urlimage
                                                      .toString(),
                                                  redirectUrl: renders.urlroute
                                                      .toString(),
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
                                ],
                              );
                            }
                          } catch (e) {
                            // Exibe uma mensagem de erro se não conseguir decodificar JSON
                            return Center(
                              child: Text(
                                  "Erro ao processar a resposta: ${e.toString()}"),
                            );
                          }
                        } else {
                          // Exibe o código de status HTTP e a resposta bruta
                          return Center(
                            child: ErrorPost(
                                text:
                                    "Plano não encontrado. \n\nVerifique sua conexão, por gentileza."),
                          );
                        }
                      } else {
                        return Center(
                          child: SecundaryText(
                            align: TextAlign.center,
                            color: nightColor,
                            text: "Nenhum Texto encontrado.",
                          ),
                        );
                      }
                    }),
              ),
            );
          });
  }
}










// ListView(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     children: [
//                                       Padding(
//                                         padding: defaultPaddingHorizon,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.stretch,
//                                           children: [
//                                             DefaultTitle(
//                                               title:
//                                                   "Você não possui nenhum plano.",
//                                             ),
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                               child: SizedBox(
//                                                   height: 235,
//                                                   child: Image.asset(
//                                                     "assets/images/illustrator/illustrator2.png",
//                                                     fit: BoxFit.cover,
//                                                   )),
//                                             ),
//                                             SizedBox(
//                                               height: 40,
//                                             ),
//                                             SubText(
//                                               text:
//                                                   "Adquira para aproveitar o máximo de benefícios que temos a oferecer para você, sua família e sua empresa! ",
//                                               color: nightColor,
//                                               align: TextAlign.start,
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Icon(Icons.arrow_drop_down),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: defaultPadding,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: DefaultButton(
//                                               padding: defaultPadding,
//                                               color: SeventhColor,
//                                               colorText: lightColor,
//                                               text: "Fazer Upgrade!",
//                                               icon: Icons.home),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               );