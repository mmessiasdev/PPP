import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/contentproduct.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';

class HomePageCoursesScreen extends StatefulWidget {
  const HomePageCoursesScreen({super.key});

  @override
  State<HomePageCoursesScreen> createState() => _HomePageCoursesScreenState();
}

class _HomePageCoursesScreenState extends State<HomePageCoursesScreen> {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      children: [
        Container(
          child: Padding(
            padding: defaultPadding,
            child: SecundaryText(
                text: 'Nossas aulinhas para os papais e mamães!',
                color: nightColor,
                align: TextAlign.start),
          ),
        ),
        FutureBuilder<List<CoursesModel>>(
          future: RemoteAuthService().getCourses(token: token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Nenhum video disponível no momento."),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var renders = snapshot.data![index];
                    return ContentProduct(
                        drules: renders.desc.toString(),
                        title: renders.title.toString(),
                        bgcolor: SecudaryColor,
                        urlThumb: renders.urlbanner.toString(),
                        id: renders.id.toString());
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
      ],
    ));
  }
}
