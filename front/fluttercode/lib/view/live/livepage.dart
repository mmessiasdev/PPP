import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'dart:math';

final String localUserID = Random().nextInt(100000).toString();

// integrate code :
class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  final String username;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: int.parse(dotenv.env["APPSIGN"].toString()),
        appSign: dotenv.env["APPSIGN"].toString(),
        userID: localUserID,
        userName: username,
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}

// import 'package:Prontas/view/live/livepage.dart';
// import 'package:flutter/material.dart';




// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);

//   /// Users who use the same liveID can join the same live streaming.
//   final liveTextCtrl =
//       TextEditingController(text: Random().nextInt(10000).toString());

//   @override
//   Widget build(BuildContext context) {
//     var buttonStyle = ElevatedButton.styleFrom(
//       fixedSize: const Size(120, 60),
//     );

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('User ID:$localUserID'),
//             const Text('Please test with two or more devices'),
//             TextFormField(
//               controller: liveTextCtrl,
//               decoration: const InputDecoration(labelText: "join a live by id"),
//             ),
//             const SizedBox(height: 20),
//             // click me to navigate to LivePage
//             ElevatedButton(
//               style: buttonStyle,
//               child: const Text('Start a live'),
//               onPressed: () => jumpToLivePage(
//                 context,
//                 liveID: liveTextCtrl.text,
//                 isHost: true,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // click me to navigate to LivePage
//             ElevatedButton(
//               style: buttonStyle,
//               child: const Text('Watch a live'),
//               onPressed: () => jumpToLivePage(
//                 context,
//                 liveID: liveTextCtrl.text,
//                 isHost: false,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }