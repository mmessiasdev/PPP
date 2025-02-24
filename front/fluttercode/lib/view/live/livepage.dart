import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/containersLoading.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String username;
  final String id;
  final String codlive;

  const LivePage({
    Key? key,
    required this.codlive,
    required this.liveID,
    this.isHost = false,
    required this.username,
    required this.id,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  bool isRecording = false;

  @override
  void initState() {
    super.initState();

    // Registra os callbacks de gravação
    ZegoExpressEngine.onCapturedDataRecordStateUpdate = (
      ZegoDataRecordState state,
      int errorCode,
      ZegoDataRecordConfig config,
      ZegoPublishChannel channel,
    ) {
      if (state == ZegoDataRecordState.Recording) {
        setState(() {
          isRecording = true;
        });
        debugPrint("Gravação iniciada!");
      } else if (state == ZegoDataRecordState.NoRecord) {
        setState(() {
          isRecording = false;
        });
        debugPrint("Gravação finalizada!");
      } else if (errorCode != 0) {
        debugPrint("Erro de gravação: $errorCode");
      }
    };

    ZegoExpressEngine.onCapturedDataRecordProgressUpdate = (
      ZegoDataRecordProgress progress,
      ZegoDataRecordConfig config,
      ZegoPublishChannel channel,
    ) {
      debugPrint("Progresso da gravação: ${progress.currentFileSize} bytes");
    };
  }

  // Inicia a gravação
  void startRecording() {
    setState(() {
      isRecording = true;
    });

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath =
        "/storage/emulated/0/Download/live_recording_$timestamp.mp4";

    final ZegoDataRecordConfig recordConfig =
        ZegoDataRecordConfig(filePath, ZegoDataRecordType.AudioAndVideo);

    ZegoExpressEngine.instance.startRecordingCapturedData(recordConfig,
        channel: ZegoPublishChannel.Main);

    debugPrint("Gravação iniciada em: $filePath");
  }

  // Para a gravação
  void stopRecording() {
    setState(() {
      isRecording = false;
    });

    ZegoExpressEngine.instance
        .stopRecordingCapturedData(channel: ZegoPublishChannel.Main);
  }

  void copyLiveCode(String liveCode) {
    Clipboard.setData(ClipboardData(text: liveCode));
    EasyLoading.showSuccess("Código da live copiado: $liveCode");
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return Column(
        children: [
          MainHeader(
            title: "Prontas",
            icon: Icons.arrow_back_ios,
            onClick: () {
              (Navigator.pop(context));
            },
          ),
          Expanded(
            child: Center(
              child: ErrorPost(
                text: "Live Streaming não está disponível nesta plataforma.",
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
              appID: int.parse(dotenv.env["APPID"].toString()),
              appSign: dotenv.env["APPSIGN"].toString(),
              userID: widget.id,
              userName: widget.username,
              liveID: widget.liveID,
              config: widget.isHost
                  ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                  : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
            ),
            if (widget.isHost)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 70, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 2,
                      children: [
                        SubText(
                          color: lightColor,
                          text: "Código da live: ${widget.codlive}",
                          align: TextAlign.end,
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: lightColor),
                          onPressed: () => copyLiveCode(widget.codlive),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 50),
                        child: ElevatedButton(
                          onPressed:
                              isRecording ? stopRecording : startRecording,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isRecording ? SecudaryColor : PrimaryColor,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                          ),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.play_arrow,
                            color: lightColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
