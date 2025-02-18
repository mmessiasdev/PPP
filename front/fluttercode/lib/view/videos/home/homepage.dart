import 'package:Prontas/component/categorie.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/contentproduct.dart';
import 'package:Prontas/component/coursecontent.dart';
import 'package:Prontas/component/inputdefault.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/widgets/iconlist.dart';
import 'package:Prontas/controller/auth.dart';
import 'package:Prontas/model/categoriescareers.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class HomePageCareers extends StatefulWidget {
  const HomePageCareers({super.key});

  @override
  State<HomePageCareers> createState() => _HomePageCareersState();
}

class _HomePageCareersState extends State<HomePageCareers> {
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          Padding(
                            padding: defaultPadding,
                            child: SecundaryText(
                                text: 'Playlists feitas pra você!',
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
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var renders = snapshot.data![index];
                                      return CourseContent(
                                        urlThumb: renders.urlbanner.toString(),
                                        subtitle: "${renders.desc}",
                                        title: renders.title.toString(),
                                        id: renders.id.toString(),
                                        time: "",
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
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(),
              ],
            ),
          );
  }
}
