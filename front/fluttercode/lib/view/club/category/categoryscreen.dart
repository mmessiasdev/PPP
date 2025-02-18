import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/contentproduct.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/component/widgets/searchInput.dart';
import 'package:Prontas/model/categoriesclub.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key, required this.id});
  var id;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  var token;

  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();

    setState(() {
      token = strToken.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: token == "null"
            ? SizedBox()
            : LayoutBuilder(builder: (context, constraints) {
                bool isDesktop = constraints.maxWidth > 800;

                return Scaffold(
                    body: Column(
                  children: [
                    FutureBuilder<Map>(
                        future: RemoteAuthService()
                            .getOneCategory(token: token, id: widget.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var render = snapshot.data!;
                            return SizedBox(
                              child: Padding(
                                padding: defaultPadding,
                                child: Column(
                                  children: [
                                    const SearchClubInput(),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    MainHeader(
                                        title: render["name"],
                                        icon: Icons.arrow_back_ios,
                                        onClick: () {
                                          (Navigator.pop(context));
                                        }),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Image.network(
                                          render['illustrationurl'] ?? "",
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Expanded(
                              child: Center(
                                  child: SubText(
                                text: 'Erro ao pesquisar Categoria',
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
                    Expanded(
                      child: FutureBuilder<List<OnlineStores>>(
                        future: RemoteAuthService()
                            .getOneCategoryStories(token: token, id: widget.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              // gridDelegate:
                              //     const SliverGridDelegateWithFixedCrossAxisCount(
                              //   crossAxisCount: 2,
                              //   crossAxisSpacing: 1,
                              //   mainAxisSpacing: 1,
                              //   childAspectRatio: 0.75, // Proporção padrão
                              // ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var renders = snapshot.data![index];
                                if (renders != null) {
                                  return ContentProduct(
                                    bgcolor: SixthColor,
                                    urlLogo: renders.logourl.toString(),
                                    drules:
                                        "${renders.percentcashback}% de cashback",
                                    title: renders.name.toString(),
                                    id: renders.id.toString(),
                                    maxl: 1,
                                    over: TextOverflow.fade,
                                  );
                                }
                                return SizedBox(
                                    height: 300,
                                    child: ErrorPost(
                                        text:
                                            'Não encontrado. \n\nVerifique sua conexão, por gentileza.'));
                              },
                            );
                          }
                          return SizedBox(
                              height: 300,
                              child: ErrorPost(text: 'Carregando...'));
                        },
                      ),
                    ),
                  ],
                ));
              }),
      ),
    );
  }
}
