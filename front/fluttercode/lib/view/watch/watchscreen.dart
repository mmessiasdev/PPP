// import 'dart:async';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class LiveStreamMonitor extends StatefulWidget {
//   const LiveStreamMonitor({Key? key}) : super(key: key);

//   @override
//   State<LiveStreamMonitor> createState() => _LiveStreamMonitorState();
// }

// class _LiveStreamMonitorState extends State<LiveStreamMonitor> {
//   final String appId = dotenv.env["AGAPPID"].toString();
//   final String token = dotenv.env["AGTEMPTOKEN"].toString();
//   final String channel = dotenv.env["AGNAME"].toString();

//   late RtcEngine _engine;
//   bool _isBroadcasterOnline = false;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     // Inicializa o motor do Agora
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     // Monitora os eventos de entrada e saída dos usuários
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("Remote user $remoteUid joined");
//           setState(() {
//             _isBroadcasterOnline = true;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("Remote user $remoteUid left");
//           setState(() {
//             _isBroadcasterOnline = false;
//           });
//         },
//       ),
//     );

//     // Entra no canal como audiência
//     await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Live Stream Monitor'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _isBroadcasterOnline ? Icons.videocam : Icons.videocam_off,
//               color: _isBroadcasterOnline ? Colors.green : Colors.red,
//               size: 80,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _isBroadcasterOnline
//                   ? 'Um usuário está ao vivo!'
//                   : 'Nenhum usuário está ao vivo.',
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
