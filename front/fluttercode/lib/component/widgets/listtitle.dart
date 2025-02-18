import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecundaryText(
          text: title,
          color: nightColor,
          align: TextAlign.start,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
