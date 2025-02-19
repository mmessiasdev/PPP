import 'package:Prontas/component/containerpaycourse.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/coursecontent.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class HomePageCoursesScreen extends StatefulWidget {
  const HomePageCoursesScreen({super.key});

  @override
  State<HomePageCoursesScreen> createState() => _HomePageCoursesScreenState();
}

class _HomePageCoursesScreenState extends State<HomePageCoursesScreen> {
  var client = http.Client();

  String screen = "online";
  bool isButtonEnabled = false;

  String? fname;
  String? fullname;

  bool teacher = false;

  var id;
  bool public = false;

  var token;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strfullname = await LocalAuthService().getFullName();

    if (mounted) {
      setState(() {
        token = strToken.toString();
        fullname = strfullname;
      });
    }
  }

  TextEditingController cpf = TextEditingController();

  Widget ManutentionErro() {
    return ErrorPost(
      text: "Estamos passando por uma manutenção. Entre novamente mais tarde!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const SizedBox()
        : SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: defaultPaddingHorizon,
                  child: MainHeader(
                    title: "Prontas",
                    maxl: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: SecudaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 35,
                          ),
                          Padding(
                            padding: defaultPadding,
                            child: SecundaryText(
                                text:
                                    'Aulinhas para ajudar você mamãe e papai!',
                                color: nightColor,
                                align: TextAlign.start),
                          ),
                          FutureBuilder<List<CoursesModel>>(
                            future:
                                RemoteAuthService().getCourses(token: token),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var renders = snapshot.data![index];
                                      return ContainerPayCourse(
                                          title: renders.title.toString(),
                                          id: renders.id.toString());
                                    },
                                  );
                                }
                              } else if (snapshot.hasError) {
                                return const WidgetLoading();
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
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(),
              ],
            ),
          );
  }
}
