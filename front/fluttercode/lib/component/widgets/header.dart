import 'package:flutter/material.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';

class MainHeader extends StatelessWidget {
  MainHeader(
      {Key? key,
      required this.title,
      this.onClick,
      this.icon,
      this.over,
      this.maxl})
      : super(key: key);
  String title;
  final Function? onClick;
  IconData? icon;
  TextOverflow? over;
  int? maxl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100,
                  child: Image.asset('assets/images/logo/image.png')),
              SizedBox(
                height: 20,
              ),
              // SecundaryText(
              //     text: title, color: nightColor, align: TextAlign.start)
            ],
          ),
          GestureDetector(
            onTap: () => onClick!(),
            child: Icon(
              icon,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
