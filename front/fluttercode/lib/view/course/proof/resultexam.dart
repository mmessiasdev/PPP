import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:flutter/material.dart';

class SucessExamResult extends StatelessWidget {
  SucessExamResult(
      {super.key, required this.nameCourse, required this.resultNumber});
  String nameCourse;
  var resultNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              MainHeader(title: "Finalizado!", maxl: 2,),
              SizedBox(
                height: 35,
              ),
              Expanded(
                child: ListView(
                  children: [
                    SecundaryText(
                        text: 'Sua nota:',
                        color: nightColor,
                        align: TextAlign.center),
                    SubText(
                        text: resultNumber.toString(), align: TextAlign.center),
                    SizedBox(
                      height: 35,
                    ),
                    SubText(
                        text:
                            'Parabéns, você concluiu seu curso "${nameCourse}". Seu certificado já está pronto! Basta clicar em “Concluir” ou ir até seu perfil.',
                        align: TextAlign.start),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.network(
                        "https://cdni.iconscout.com/illustration/premium/thumb/happy-people-illustration-download-in-svg-png-gif-file-formats--rejoicing-man-running-woman-girl-profession-pack-illustrations-3613847.png?f=webp",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  (Navigator.pop(context));
                },
                child: DefaultButton(
                  color: SeventhColor,
                  colorText: lightColor,
                  text: "Finalizar",
                  padding: defaultPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FailedExamResult extends StatelessWidget {
  FailedExamResult({super.key, required this.resultNumber});
  var resultNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              MainHeader(title: "Resultado..."),
              SizedBox(
                height: 35,
              ),
              Expanded(
                child: ListView(
                  children: [
                    SecundaryText(
                        text: 'Sua nota:',
                        color: nightColor,
                        align: TextAlign.center),
                    SubText(
                        text: resultNumber.toString(), align: TextAlign.center),
                    SizedBox(
                      height: 35,
                    ),
                    SubText(
                        text:
                            'Infelizmente você não consegiu alcançar a pontuação máxima. Favor, realiar novamente.',
                        align: TextAlign.start),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.network(
                        "https://cdni.iconscout.com/illustration/premium/thumb/sad-girl-illustration-download-in-svg-png-gif-file-formats--public-depression-african-feel-negative-bullying-employee-pack-business-illustrations-2639225.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () {
                  (Navigator.pop(context));
                },
                child: DefaultButton(
                  color: FifthColor,
                  colorText: lightColor,
                  text: "Finalizar",
                  padding: defaultPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
