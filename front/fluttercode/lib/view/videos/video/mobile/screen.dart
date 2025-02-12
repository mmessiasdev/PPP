import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreenMobile extends StatefulWidget {
  final String id;
  final String urlbanner;

  const VideoScreenMobile(
      {super.key, required this.id, required this.urlbanner});

  @override
  State<VideoScreenMobile> createState() => _VideoScreenMobileState();
}

class _VideoScreenMobileState extends State<VideoScreenMobile> {
  var token;
  YoutubePlayerController? _controller;
  String? videoId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    setState(() {
      token = strToken.toString();
    });

    if (token != null) {
      fetchVideo();
    }
  }

  void fetchVideo() async {
    var response =
        await RemoteAuthService().getOneVideo(token: token, id: widget.id);

    if (response != null && response.containsKey("url")) {
      String? videoUrl = response["url"];
      String extractedVideoId =
          YoutubePlayer.convertUrlToId(videoUrl ?? "") ?? "NjJJGfwK3NI";

      setState(() {
        videoId = extractedVideoId;
        _controller = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: token == null
            ? const Center(
                child: CircularProgressIndicator()) // Aguarda o token
            : videoId == null
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Aguarda o vídeo carregar
                : Padding(
                    padding: defaultPaddingHorizon,
                    child: ListView(
                      children: [
                        MainHeader(
                          maxl: 4,
                          title: "Prontas",
                          icon: Icons.arrow_back_ios,
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: defaultPaddingVertical,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: YoutubePlayer(
                              controller: _controller!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: PrimaryColor,
                            ),
                          ),
                        ),
                        // SecundaryText(
                        //     text:
                        //         "Nome do vídeo", // Você pode substituir isso pelo nome vindo da API
                        //     color: nightColor,
                        //     align: TextAlign.center),
                        const SizedBox(height: 35),

                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: DefaultButton(
                        //     text: "Marcar como visto",
                        //     padding: defaultPadding,
                        //     color: FourtyColor,
                        //     colorText: lightColor,
                        //   ),
                        // ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
      ),
    );
  }
}
