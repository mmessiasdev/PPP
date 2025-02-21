import 'package:Prontas/component/bannerlist.dart';
import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/buttons/itembuttom.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/videos/playlistthumb.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/carrouselbanners.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/account/account.dart';
import 'package:Prontas/view/videos/coursescreen.dart';
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
        : LayoutBuilder(builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;

            return SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizon,
                    child: MainHeader(
                        title: "Prontas",
                        icon: Icons.menu,
                        onClick: () => _showDraggableScrollableSheet(context)),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  // Caroulsel --------------

                  FutureBuilder<List<Banners>>(
                    future: RemoteAuthService()
                        .getCarrouselBanners(token: token, id: "1"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: BannerList(
                                  imageUrl: renders.urlimage.toString(),
                                  redirectUrl: renders.urlroute.toString(),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: (320 * 9) / 16,
                              autoPlay:
                                  true, // Habilita o deslizamento automático
                              autoPlayInterval:
                                  const Duration(seconds: 3), // Intervalo
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
                    height: 75,
                  ),

                  // Buttons -------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ItemButtom(
                        title: "Carterinha",
                        icon: Icons.add,
                      ),
                      ItemButtom(
                        title: "Carterinha",
                        icon: Icons.add,
                      ),
                      ItemButtom(
                        title: "Carterinha",
                        icon: Icons.add,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),

                  // Playlist ----------------------
                  Column(
                    children: [
                      SecundaryText(
                        text: "Nossas playlists excluivas :)",
                        color: nightColor,
                        align: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FutureBuilder<List<CoursesModel>>(
                          future: RemoteAuthService().getCourses(token: token),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                      "Nenhum video disponível no momento."),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var renders = snapshot.data![index];
                                    return Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: PlaylistThumb(
                                        widroute: CourseScreen(
                                            id: renders.id.toString(),
                                            urlbanner:
                                                renders.urlbanner.toString()),
                                        urlThumb: renders.urlbanner.toString(),
                                        title: renders.title.toString(),
                                        id: renders.id.toString(),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else if (snapshot.hasError) {
                              return WidgetLoading();
                            }
                            return Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: nightColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
  }
}
