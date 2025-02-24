import 'package:Prontas/component/containerpaycourse.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/videos/playlistthumb.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/course/coursescreen.dart';
import 'package:Prontas/view/freeplaylist/coursescreen.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:http/http.dart' as http;

class CoursesHomePage extends StatefulWidget {
  const CoursesHomePage({super.key});

  @override
  State<CoursesHomePage> createState() => _CoursesHomePageState();
}

class _CoursesHomePageState extends State<CoursesHomePage> {
  var client = http.Client();
  String? token;
  String? fullname;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strFullname = await LocalAuthService().getFullName();

    setState(() {
      token = strToken.toString();
      fullname = strFullname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: lightColor,
            body: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizon,
                    child: MainHeader(
                      title: "Prontas",
                      maxl: 2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        Padding(
                          padding: defaultPadding,
                          child: SecundaryText(
                            text: 'Aulinhas para ajudar você mamãe e papai!',
                            color: nightColor,
                            align: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<CoursesModel>>(
                          future: RemoteAuthService().getCourses(token: token!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color: nightColor),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Erro ao carregar os cursos: ${snapshot.error}"),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child:
                                    Text("Nenhum vídeo disponível no momento."),
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var course = snapshot.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: PlaylistThumb(
                                      widroute: CoursePayScreen(
                                        id: course.id.toString(),
                                        urlbanner: course.urlbanner.toString(),
                                      ),
                                      urlThumb: course.urlbanner,
                                      title: course.desc.toString(),
                                      subtitle:
                                          "Tempo do curso: ${course.time.toString()} minutos",
                                      terciaryText: course.price ?? "Grátis",
                                      id: course.id.toString(),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
