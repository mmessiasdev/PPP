import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';

class CardBaby extends StatelessWidget {
  CardBaby({super.key, this.title, this.text, this.subtext, this.pedaltext});

  String? title;
  String? text;
  String? subtext;
  String? pedaltext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SecundaryText(
          color: nightColor,
          text: title ?? "",
          align: TextAlign.start,
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: SecudaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
              padding: defaultPadding,
              child: Column(
                children: [
                  SubTextSized(
                      size: 18,
                      fontweight: FontWeight.w600,
                      color: lightColor,
                      text: text ?? "",
                      align: TextAlign.start),
                  SizedBox(
                    height: 15,
                  ),
                  SubText(text: subtext ?? "", align: TextAlign.start),
                  SubText(text: pedaltext ?? "", align: TextAlign.start),
                ],
              )),
        ),
      ],
    );
  }
}
