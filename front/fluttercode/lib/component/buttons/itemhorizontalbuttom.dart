import 'package:Prontas/component/buttons/itembuttom.dart';
import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';

class ItemHorizontalButtom extends StatelessWidget {
  ItemHorizontalButtom({super.key, required this.title, required this.icon});
  String title;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemButtom(icon: icon),
        SubText(
          text: title,
          align: TextAlign.center,
        ),
      ],
    );
  }
}
