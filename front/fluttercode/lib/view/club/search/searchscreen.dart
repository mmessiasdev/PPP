import 'package:Prontas/component/categorie.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/searchInput.dart';
import 'package:Prontas/model/categoriesclub.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var client = http.Client();

  String screen = "online";

  String? token;
  String? fname;
  var id;
  bool public = false;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: SearchClubInput(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: PrimaryColor),
              child: Padding(
                padding: defaultPadding,
                child: ListView(
                  children: [
                    FutureBuilder<List<CategoryOnlineStoreModel>>(
                        future: RemoteAuthService()
                            .getCategoriesOnlineStores(token: token),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var renders = snapshot.data![index];
                                  print(renders);
                                  if (renders != null) {
                                    return Column(
                                      children: [
                                        Center(
                                            child: CategorieClub(
                                          title: renders.name.toString(),
                                          illurl: renders.illustrationurl
                                              .toString(),
                                          id: renders.id.toString(),
                                        )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox(
                                      height: 300,
                                      child: ErrorPost(
                                          text:
                                              'Não encontrado. \n\nVerifique sua conexão, por gentileza.'));
                                });
                          }
                          return SizedBox(
                              height: 300,
                              child: ErrorPost(
                                  text:
                                      'Categorias não encontrada. \n\nVerifique sua conexão, por gentileza.'));
                        }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
