import 'package:Prontas/component/buttons/itembuttom.dart';
import 'package:Prontas/component/buttons/itemhorizontalbuttom.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/cardbaby.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/prenatal/consultations.dart';
import 'package:Prontas/model/prenatal/exams.dart';
import 'package:Prontas/model/prenatal/medicines.dart';
import 'package:Prontas/model/prenatal/vaccines.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/prenatalwallet/post.dart';
import 'package:Prontas/view/prenatalwallet/timelineprenatal.dart';
import 'package:flutter/material.dart';

class AddPrenatalScreen extends StatefulWidget {
  const AddPrenatalScreen({super.key});

  @override
  State<AddPrenatalScreen> createState() => _AddPrenatalScreenState();
}

class _AddPrenatalScreenState extends State<AddPrenatalScreen> {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      return SafeArea(
        child: token == null
            ? const SizedBox()
            : Scaffold(
                backgroundColor: lightColor,
                body: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: MainHeader(
                            title: "Adicone itens a sua carteirinha!",
                            maxl: 3,
                            icon: Icons.arrow_back_ios,
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        // PrenatalTimelineScreen(),
                        // Padding(
                        //   padding: defaultPadding,
                        //   child: RichDefaultText(
                        //     text: "Aqui fica sua carteinha de \n",
                        //     wid: SubText(
                        //         text: "Prenatal!", align: TextAlign.start),
                        //   ),
                        // ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: defaultPadding,
                          child: SizedBox(
                            width: isDesktop ? 600 : double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddConsultationsScreen(),
                                            ),
                                          );
                                        },
                                        child: ItemHorizontalButtom(
                                          title: "Consultas",
                                          icon: Icons.add,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddConsultationsScreen(),
                                            ),
                                          );
                                        },
                                        child: ItemHorizontalButtom(
                                          title: "Medicamentos",
                                          icon: Icons.add,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddConsultationsScreen(),
                                            ),
                                          );
                                        },
                                        child: ItemHorizontalButtom(
                                          title: "Exames",
                                          icon: Icons.add,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddConsultationsScreen(),
                                            ),
                                          );
                                        },
                                        child: ItemHorizontalButtom(
                                          title: "Vacinas",
                                          icon: Icons.add,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                FutureBuilder<List<PrenatalConsultations>>(
                                  future: RemoteAuthService()
                                      .getPrenatalConsultations(token: token),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Text(
                                                "Nenhum card disponível no momento."),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SecundaryText(
                                                  color: nightColor,
                                                  text: "Consultas",
                                                  align: TextAlign.start,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddConsultationsScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.add),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  var renders =
                                                      snapshot.data![index];
                                                  // Verificação se o idPlan não é nulo
                                                  return CardBaby(
                                                    text: renders.professional,
                                                    subtext:
                                                        renders.obs.toString(),
                                                    pedaltext:
                                                        renders.data.toString(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return WidgetLoading();
                                    }
                                    return SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: nightColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                FutureBuilder<List<PrenatalMedicines>>(
                                  future: RemoteAuthService()
                                      .getPrenatalMedicines(token: token),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Text(
                                                "Nenhuma loja disponível no momento."),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SecundaryText(
                                                  color: nightColor,
                                                  text: "Medicamentos",
                                                  align: TextAlign.start,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddMedicinesScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.add),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  var renders =
                                                      snapshot.data![index];
                                                  // Verificação se o idPlan não é nulo
                                                  return Column(
                                                    children: [
                                                      CardBaby(
                                                        title: "Medicamentos",
                                                        text: renders.name
                                                            .toString(),
                                                        subtext: renders.obs
                                                            .toString(),
                                                        pedaltext: renders
                                                            .dosage
                                                            .toString(),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return WidgetLoading();
                                    }
                                    return SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: nightColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                FutureBuilder<List<PrenatalExams>>(
                                  future: RemoteAuthService()
                                      .getPrnatalExams(token: token),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Text(
                                                "Nenhuma loja disponível no momento."),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SecundaryText(
                                                  color: nightColor,
                                                  text: "Exames",
                                                  align: TextAlign.start,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddExamScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.add),
                                                )
                                              ],
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                var renders =
                                                    snapshot.data![index];
                                                // Verificação se o idPlan não é nulo
                                                return Column(
                                                  children: [
                                                    CardBaby(
                                                      text: renders.type
                                                          .toString(),
                                                      subtext: renders.result
                                                          .toString(),
                                                      pedaltext: renders.data
                                                          .toString(),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return WidgetLoading();
                                    }
                                    return SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: nightColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                FutureBuilder<List<PrenatalVaccines>>(
                                  future: RemoteAuthService()
                                      .getPrenatalVaccines(token: token),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Text(
                                                "Nenhuma loja disponível no momento."),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SecundaryText(
                                                  color: nightColor,
                                                  text: "Vacinas",
                                                  align: TextAlign.start,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddVaccinesScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(Icons.add),
                                                )
                                              ],
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                var renders =
                                                    snapshot.data![index];
                                                // Verificação se o idPlan não é nulo
                                                return CardBaby(
                                                  title: "Vacinas",
                                                  text: renders.name.toString(),
                                                  subtext:
                                                      renders.date.toString(),
                                                  pedaltext: renders.nextdose
                                                      .toString(),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return WidgetLoading();
                                    }
                                    return SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: nightColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
