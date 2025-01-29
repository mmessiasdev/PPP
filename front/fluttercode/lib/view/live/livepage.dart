import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

final String localUserID = Random().nextInt(100000).toString();

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String username;
  final String id;

  const LivePage({
    Key? key,
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
    final ZegoDataRecordConfig recordConfig = ZegoDataRecordConfig(
        "/storage/emulated/0/Download/live_recording.mp4",
        ZegoDataRecordType.AudioAndVideo);

    ZegoExpressEngine.instance.startRecordingCapturedData(recordConfig,
        channel: ZegoPublishChannel.Main);
  }

  // Para a gravação
  void stopRecording() {
    ZegoExpressEngine.instance
        .stopRecordingCapturedData(channel: ZegoPublishChannel.Main);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return Center(
        child: SubText(
          text: "Live Streaming não está disponível nesta plataforma.",
          align: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Streaming com Gravação"),
      ),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: isRecording ? stopRecording : startRecording,
                    child: Text(
                        isRecording ? "Parar Gravação" : "Iniciar Gravação"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
