import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';

class ItemButtom extends StatelessWidget {
  ItemButtom({super.key, this.title, required this.icon});
  String? title;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: PrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: lightColor,
                  size: 35,
                ),
              ),
            ),
            title != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      SubText(text: title ?? "", align: TextAlign.center),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
