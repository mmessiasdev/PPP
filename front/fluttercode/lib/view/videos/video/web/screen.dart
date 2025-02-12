import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreenWeb extends StatefulWidget {
  final String id;
  final String urlbanner;

  const VideoScreenWeb({super.key, required this.id, required this.urlbanner});

  @override
  State<VideoScreenWeb> createState() => _VideoScreenWebState();
}

class _VideoScreenWebState extends State<VideoScreenWeb> {
  var token;
  late YoutubePlayerController _controller;
  String videoId = "NjJJGfwK3NI"; // ID padrão até que a API carregue os dados

  @override
  void initState() {
    super.initState();
    getString();
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: videoId);
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    setState(() {
      token = strToken.toString();
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: token == "null"
            ? const SizedBox()
            : FutureBuilder<Map>(
                future: RemoteAuthService()
                    .getOneVideo(token: token, id: widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: SubText(
                          text: 'Erro ao carregar vídeo',
                          color: PrimaryColor,
                          align: TextAlign.center),
                    );
                  }

                  if (snapshot.hasData) {
                    var render = snapshot.data!;
                    String? videoUrl =
                        render["url"]; // Ajuste conforme o retorno da API
                    String extractedVideoId =
                        YoutubePlayerController.convertUrlToId(
                                videoUrl ?? "") ??
                            videoId;

                    // Atualiza o vídeo se necessário
                    if (extractedVideoId != videoId) {
                      videoId = extractedVideoId;
                      _controller.loadVideoById(videoId: videoId);
                    }

                    return LayoutBuilder(builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 800;
                      return Center(
                        child: Padding(
                          padding: defaultPaddingHorizon,
                          child: SizedBox(
                            width: isDesktop ? 600 : double.infinity,
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
                                    child: YoutubePlayerScaffold(
                                      controller: _controller,
                                      builder: (context, player) {
                                        return player;
                                      },
                                    ),
                                  ),
                                ),
                                SecundaryText(
                                    text: render["name"] ?? "",
                                    color: nightColor,
                                    align: TextAlign.center),

                                const SizedBox(height: 35),
                                SubText(
                                    text: render["desc"] ?? "",
                                    color: nightColor,
                                    align: TextAlign.start),
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
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }

                  return const SizedBox();
                },
              ),
      ),
    );
  }
}
