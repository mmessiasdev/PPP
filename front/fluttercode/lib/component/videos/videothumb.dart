import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/view/videos/video/videoscreen.dart';
import 'package:flutter/material.dart';

class VideoThumb extends StatelessWidget {
  VideoThumb(
      {super.key,
      this.subtitle,
      this.time,
      required this.title,
      this.urlThumb,
      this.maxl,
      this.over,
      this.bgcolor,
      this.urlbanner,
      this.price,
      required this.id});

  final String? subtitle;
  final String? time;

  final String title;
  final String? urlThumb;
  String id;
  int? maxl;
  String? price;
  TextOverflow? over;
  Color? bgcolor;
  String? urlbanner;
  bool whatch = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoScreen(
                      id: id,
                      urlbanner: urlThumb ?? "",
                    )),
          );
        },
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: bgcolor ?? lightColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: nightColor.withOpacity(0.2), // Cor e opacidade da sombra
                spreadRadius: 2, // Expansão da sombra
                blurRadius: 5, // Desfoque
                offset: Offset(0, 3), // Deslocamento (horizontal, vertical)
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Imagem de fundo
                Positioned.fill(
                  child: Image.network(
                    urlThumb ?? "", // Substitua pelo caminho da sua imagem
                    fit: BoxFit.cover, // Para cobrir todo o espaço disponível
                  ),
                ),
                // Gradiente horizontal
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          SecudaryColor.withOpacity(0.8),
                          nightColor.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                // Conteúdo sobre a imagem
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      ),
                      SecundaryText(
                        text: title,
                        color: lightColor,
                        align: TextAlign.end,
                        maxl: maxl,
                        over: over,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SubText(
                            text: "${time ?? "0"} minutos",
                            color: lightColor,
                            align: TextAlign.end,
                            maxl: 8,
                            over: TextOverflow.fade,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.timer,
                            color: lightColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
