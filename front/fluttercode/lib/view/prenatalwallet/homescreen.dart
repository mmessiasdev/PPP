// import 'package:flutter/material.dart';

// class PreNatalScreen extends StatelessWidget {
//   final Map<String, dynamic> preNatalData = {
//     "numero": "123456789",
//     "consultas": [
//       {
//         "data": "2025-01-15",
//         "observacoes": "Tudo dentro da normalidade.",
//         "profissional": "Dr. João"
//       }
//     ],
//     "exames": [
//       {
//         "tipo": "Ultrassonografia",
//         "data": "2025-01-10",
//         "resultado": "Bebê saudável."
//       }
//     ],
//     "medicamentos": [
//       {
//         "nome": "Ácido fólico",
//         "posologia": "1 comprimido ao dia",
//         "observacoes": "Tomar sempre pela manhã."
//       }
//     ],
//     "vacinas": [
//       {"nome": "Tétano", "data": "2025-01-01", "proximaDose": "2025-02-01"}
//     ]
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Carteira de Pré-Natal"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Número do Pré-Natal"),
//             _buildCard(preNatalData['numero']),
//             _buildSectionTitle("Consultas"),
//             _buildList(
//                 preNatalData['consultas'],
//                 (consulta) => "Data: ${consulta['data']}\n"
//                     "Profissional: ${consulta['profissional']}\n"
//                     "Observações: ${consulta['observacoes']}"),
//             _buildSectionTitle("Exames"),
//             _buildList(
//                 preNatalData['exames'],
//                 (exame) => "Tipo: ${exame['tipo']}\n"
//                     "Data: ${exame['data']}\n"
//                     "Resultado: ${exame['resultado']}"),
//             _buildSectionTitle("Medicamentos"),
//             _buildList(
//                 preNatalData['medicamentos'],
//                 (medicamento) => "Nome: ${medicamento['nome']}\n"
//                     "Posologia: ${medicamento['posologia']}\n"
//                     "Observações: ${medicamento['observacoes']}"),
//             _buildSectionTitle("Vacinas"),
//             _buildList(
//                 preNatalData['vacinas'],
//                 (vacina) => "Nome: ${vacina['nome']}\n"
//                     "Data: ${vacina['data']}\n"
//                     "Próxima dose: ${vacina['proximaDose']}"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildCard(String content) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           content,
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildList(List<dynamic> items, String Function(dynamic) format) {
//     return Column(
//       children: items.map((item) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               format(item),
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

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
import 'package:flutter/material.dart';

class PreNatalScreen extends StatefulWidget {
  const PreNatalScreen({super.key});

  @override
  State<PreNatalScreen> createState() => _PreNatalScreenState();
}

class _PreNatalScreenState extends State<PreNatalScreen> {
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
            : ListView(
                children: [
                  Column(
                    children: [
                      MainHeader(title: "Cateirinha da gestante"),
                      Padding(
                        padding: defaultPadding,
                        child: RichDefaultText(
                          text: "Aqui fica sua carteinha de \n",
                          wid: SubText(
                              text: "Prenatal!", align: TextAlign.start),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: defaultPadding,
                        child: SizedBox(
                          width: isDesktop ? 600 : double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
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
                                      return SizedBox(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            var renders = snapshot.data![index];
                                            // Verificação se o idPlan não é nulo
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
                                                                AddExamScreen(),
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(Icons.add),
                                                    )
                                                  ],
                                                ),
                                                CardBaby(
                                                  text: renders.professional,
                                                  subtext:
                                                      renders.obs.toString(),
                                                  pedaltext:
                                                      renders.data.toString(),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
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
                                                MainAxisAlignment.spaceBetween,
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
                                                          AddExamScreen(),
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
                                              itemCount: snapshot.data!.length,
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
                                                      pedaltext: renders.dosage
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
                                                MainAxisAlignment.spaceBetween,
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
                                                    text:
                                                        renders.type.toString(),
                                                    subtext: renders.result
                                                        .toString(),
                                                    pedaltext:
                                                        renders.data.toString(),
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
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          var renders = snapshot.data![index];
                                          // Verificação se o idPlan não é nulo
                                          return CardBaby(
                                            title: "Vacinas",
                                            text: renders.name.toString(),
                                            subtext: renders.date.toString(),
                                            pedaltext:
                                                renders.nextdose.toString(),
                                          );
                                        },
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
      );
    });
  }
}
