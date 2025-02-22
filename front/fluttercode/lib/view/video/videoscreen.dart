import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/view/video/mobile/screen.dart';
import 'package:Prontas/view/video/web/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Para verificar a plataforma

class VideoScreen extends StatelessWidget {
  final String id;
  final String urlbanner;

  const VideoScreen({super.key, required this.id, required this.urlbanner});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: kIsWeb
          ? VideoScreenWeb(id: id, urlbanner: urlbanner)
          : VideoScreenMobile(id: id, urlbanner: urlbanner),
    );
  }
}
