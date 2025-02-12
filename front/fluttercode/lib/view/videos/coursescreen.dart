import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/coursecontent.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/tips.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/model/video.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/videos/proof/examsscreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  CourseScreen({super.key, required this.id, required this.urlbanner});
  String id;
  String urlbanner;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  var email;
  var fullname;
  var cpf;
  var id;
  var token;
  var idInterprise;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strEmail = await LocalAuthService().getEmail();
    var strFullname = await LocalAuthService().getFullName();
    var strId = await LocalAuthService().getId();
    var strToken = await LocalAuthService().getSecureToken();

    if (mounted) {
      setState(() {
        email = strEmail.toString();
        fullname = strFullname.toString();
        id = strId.toString();

        token = strToken.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: token == "null"
            ? const SizedBox()
            : ListView(
                children: [
                  FutureBuilder<Map>(
                      future: RemoteAuthService()
                          .getOneCourse(token: token, id: widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var render = snapshot.data!;
                          return SizedBox(
                            child: Padding(
                              padding: defaultPaddingHorizon,
                              child: Column(
                                children: [
                                  MainHeader(
                                    maxl: 4,
                                    title: "Prontas",
                                    icon: Icons.arrow_back_ios,
                                    onClick: () {
                                      (Navigator.pop(context));
                                    },
                                  ),
                                  SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: defaultPaddingVertical,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: SizedBox(
                                            child: Image.network(
                                          render["urlbanner"] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                                Icons.broken_image,
                                                size: 100,
                                                color: Colors.grey);
                                          },
                                        )),
                                      ),
                                    ),
                                  ),
                                  SecundaryText(
                                    text: render["title"],
                                    color: nightColor,
                                    align: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Padding(
                                    padding: defaultPaddingVertical,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            RemoteAuthService()
                                                .putFavoriteCourse(
                                              fullname: fullname,
                                              token: token,
                                              id: render["id"].toString(),
                                              profileId: id,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.favorite,
                                            size: 35,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                             SubText(
                                              color: nightColor,
                                              text: "${render["desc"]}",
                                              align: TextAlign.end,
                                            ),
                                            // SubText(
                                            //   color: nightColor,
                                            //   text:
                                            //       "Tempo do curso: ${render["time"]} horas",
                                            //   align: TextAlign.end,
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // SubText(
                                            //   color: nightColor,
                                            //   text: "Nível: ${render["nivel"]}",
                                            //   align: TextAlign.end,
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Icon(Icons.credit_card),
                                  //     SubTextSized(
                                  //       text: render["price"] == null ||
                                  //               render["price"] == null
                                  //           ? "Grátis"
                                  //           : "${render["price"]}R\$",
                                  //       size: 26,
                                  //       align: TextAlign.end,
                                  //       fontweight: FontWeight.w600,
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: defaultPadding,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SecundaryText(
                                            text: "Vídeos da playlist",
                                            color: nightColor,
                                            align: TextAlign.start),
                                        FutureBuilder<List<Videos>>(
                                          future: RemoteAuthService()
                                              .getOneCourseVideos(
                                            token: token,
                                            id: widget.id.toString(),
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // Enquanto os dados estão sendo carregados
                                              return SizedBox(
                                                height: 300,
                                                child: ErrorPost(
                                                    text: 'Carregando...'),
                                              );
                                            }

                                            if (snapshot.hasError) {
                                              // Caso ocorra um erro na requisição
                                              return SizedBox(
                                                height: 300,
                                                child: ErrorPost(
                                                  text:
                                                      'Erro ao carregar vídeos.\n\nVerifique sua conexão.',
                                                ),
                                              );
                                            }

                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              // Caso os dados sejam carregados com sucesso
                                              final videos = snapshot.data!;
                                              if (videos.isEmpty) {
                                                return SizedBox(
                                                  height: 300,
                                                  child: ErrorPost(
                                                    text:
                                                        'Nenhum vídeo encontrado.',
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                itemCount: videos.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final video = videos[index];
                                                  return VideoContent(
                                                    urlThumb:
                                                        render["urlbanner"],
                                                    time: video.time.toString(),
                                                    title:
                                                        video.name.toString(),
                                                    id: video.id.toString(),
                                                  );
                                                },
                                              );
                                            }
                                            // Caso nenhum dado seja retornado
                                            return SizedBox(
                                              height: 300,
                                              child: ErrorPost(
                                                text:
                                                    'Não encontrado. \n\nVerifique sua conexão, por gentileza.',
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ExamsScreen(
                                        //           idProof: render["proof"]
                                        //               ["id"],
                                        //           nameCourse: render["title"],
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        //   child: DefaultButton(
                                        //     color: SeventhColor,
                                        //     padding: defaultPadding,
                                        //     text: "Pegar Cerfifticado",
                                        //     icon: Icons.document_scanner,
                                        //     colorText: lightColor,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Expanded(
                            child: Center(
                                child: SubText(
                              text: 'Erro ao pesquisar Curso',
                              color: PrimaryColor,
                              align: TextAlign.center,
                            )),
                          );
                        }
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: PrimaryColor,
                            ),
                          ),
                        );
                      }),
                ],
              ),
      ),
    );
  }
}
