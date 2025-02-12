import 'dart:convert';
import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/defaultButton.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/view/videos/proof/resultexam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/remote/auth.dart';

class ExamsScreen extends StatefulWidget {
  ExamsScreen({super.key, required this.nameCourse, required this.idProof});
  final String nameCourse;
  final int idProof;

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  late Future<Map> proofData;
  var token; // Token será carregado do storage ou recebido de outro local.
  var fullname;
  var id;

  @override
  void initState() {
    super.initState();
    proofData = fetchProofData();
  }

  Future<Map> fetchProofData() async {
    token = await LocalAuthService().getSecureToken();
    fullname = await LocalAuthService().getFullName();
    id = await LocalAuthService().getId();
    return RemoteAuthService().getOneProof(
      id: widget.idProof.toString(),
      token: token,
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: FutureBuilder<Map>(
        future: proofData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar dados: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final questions = data["questions"] as List<dynamic>;

            return ExamContent(
              questions: questions,
              fullname: fullname,
              token: token,
              profileId: id,
              idCourse: widget.idProof,
              nameCourse: widget.nameCourse,
            );
          } else {
            return Center(
              child: Text("Nenhum dado encontrado."),
            );
          }
        },
      ),
    );
  }
}

class ExamContent extends StatefulWidget {
  const ExamContent({
    Key? key,
    required this.questions,
    required this.fullname,
    required this.token,
    required this.profileId,
    required this.idCourse,
    required this.nameCourse,
  }) : super(key: key);

  final List<dynamic> questions;
  final String fullname;
  final String token;
  final String profileId;
  final int idCourse;
  final String nameCourse;

  @override
  State<ExamContent> createState() => _ExamContentState();
}

class _ExamContentState extends State<ExamContent> {
  int currentQuestionIndex = 0;
  String? selectedOption;
  int score = 0;

  void checkAnswer() {
    final currentQuestion = widget.questions[currentQuestionIndex];
    if (selectedOption == currentQuestion["correctAnswer"]) {
      score++;
    }

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
      });
    } else {
      double percentage = (score / widget.questions.length) * 100;
      if (percentage >= 70) {
        EasyLoading.showSuccess("Certificado enviado para seu currículo!");
        RemoteAuthService().putAddCerfiticates(
          token: widget.token,
          id: widget.idCourse.toString(),
          profileId: widget.profileId,
        );
        // Redireciona para resultado de sucesso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SucessExamResult(
              nameCourse: widget.nameCourse,
              resultNumber: "${percentage.toStringAsFixed(2)}%",
            ),
          ),
        );
      } else {
        // Redireciona para resultado de falha
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FailedExamResult(
              resultNumber: "${percentage.toStringAsFixed(2)}%",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeader(
                  title:
                      "${currentQuestionIndex + 1}/${widget.questions.length}",
                  icon: Icons.arrow_back_ios,
                  onClick: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
        SizedBox(height: 25),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: SecudaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SecundaryText(
                    text: currentQuestion["question"],
                    color: nightColor,
                    align: TextAlign.start,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ...currentQuestion["options"].map<Widget>((option) {
                    return RadioListTile<String>(
                      title: SubText(
                        text: option,
                        align: TextAlign.start,
                      ),
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    );
                  }).toList(),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: selectedOption != null ? checkAnswer : null,
                      child: Column(
                        children: [
                          currentQuestionIndex == widget.questions.length - 1
                              ? DefaultButton(
                                  padding: defaultPadding,
                                  text: "Finalizar",
                                  color: SeventhColor,
                                  colorText: lightColor,
                                  icon: Icons.check,
                                )
                              : DefaultButton(
                                  padding: defaultPadding,
                                  text: "Próximo",
                                  icon: Icons.arrow_right_rounded,
                                  color: PrimaryColor,
                                  colorText: lightColor,
                                )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
