import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/view/course/coursescreen.dart';
import 'package:Prontas/view/videos/coursescreen.dart';
import 'package:Prontas/view/videos/video/videoscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaylistThumb extends StatelessWidget {
  PlaylistThumb(
      {super.key,
      this.subtitle,
      this.terciaryText,
      required this.title,
      this.urlThumb,
      this.maxl,
      this.over,
      this.bgcolor,
      this.price,
      required this.widroute,
      required this.id});

  final String? subtitle;
  final String? terciaryText;
  final String title;
  final String? urlThumb;
  String id;
  int? maxl;
  String? price;
  TextOverflow? over;
  Color? bgcolor;
  Widget widroute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widroute),
        ));
      },
      child: Container(
        // decoration: BoxDecoration(
        //   color: bgcolor ?? lightColor,
        //   borderRadius: BorderRadius.circular(25),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black
        //           .withOpacity(0.2), // Cor e opacidade da sombra
        //       spreadRadius: 2, // Expansão da sombra
        //       blurRadius: 5, // Desfoque
        //       offset: Offset(0, 3), // Deslocamento (horizontal, vertical)
        //     ),
        //   ],
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  320, // Largura fixa (pode ser ajustada conforme necessário)
              height: (320 * 9) / 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: urlThumb == ""
                    ? SizedBox()
                    : Image.network(
                        urlThumb ?? "",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SubText(
                    text: title ?? "",
                    color: nightColor,
                    align: TextAlign.start,
                    maxl: 8,
                    over: TextOverflow.fade,
                  ),
                  subtitle == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            SubText(
                              text: subtitle ?? "",
                              color: nightColor,
                              align: TextAlign.start,
                              maxl: 8,
                              over: TextOverflow.fade,
                            ),
                          ],
                        ),
                  terciaryText == null
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            PrimaryText(
                              text: terciaryText ?? "",
                              color: OffColor,
                              align: TextAlign.start,
                              maxl: 2,
                              over: over,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
