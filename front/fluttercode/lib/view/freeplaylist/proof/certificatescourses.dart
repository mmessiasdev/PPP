import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/videos/playlistthumb.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/widgets/plancontainer.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/freeplaylist/coursescreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CerfiticatesCourses extends StatefulWidget {
  const CerfiticatesCourses({super.key});

  @override
  State<CerfiticatesCourses> createState() => _CerfiticatesCoursesState();
}

class _CerfiticatesCoursesState extends State<CerfiticatesCourses> {
  var token;
  var profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strProfileId = await LocalAuthService().getId();

    setState(() {
      token = strToken.toString();
      profileId = strProfileId.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: ListView(
          children: [
            Padding(
              padding: defaultPaddingHorizon,
              child: MainHeader(
                  title: "Certificados",
                  maxl: 1,
                  icon: Icons.arrow_back_ios,
                  onClick: () {
                    Navigator.pop(context);
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: FutureBuilder<List<CoursesModel>>(
                  future: RemoteAuthService().getCerfiticatesCourses(
                      token: token, profileId: profileId.toString()),
                  builder: (context, planSnapshot) {
                    if (planSnapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: planSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            var renders = planSnapshot.data![index];
                            if (renders != null) {
                              return Padding(
                                padding: defaultPaddingHorizon,
                                child: PlaylistThumb(
                                  widroute: PlaylistScreen(
                                      id: renders.id.toString(),
                                      urlbanner: renders.urlbanner.toString()),
                                  urlThumb: renders.urlbanner.toString(),
                                  subtitle: "${renders.desc}",
                                  title: renders.title.toString(),
                                  id: renders.id.toString(),
                                ),
                              );
                            }
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text('Plano não encontrado'),
                              ),
                            );
                          });
                    }
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: nightColor,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
