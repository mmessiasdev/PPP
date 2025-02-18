// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:Prontas/component/buttons.dart';
// import 'package:Prontas/component/colors.dart';
// import 'package:Prontas/component/padding.dart';
// import 'package:Prontas/component/texts.dart';
// import 'package:Prontas/component/widgets/header.dart';
// import 'package:Prontas/controller/auth.dart';
// import 'package:Prontas/service/local/auth.dart';
// import 'package:Prontas/view/club/store/local/verfiedlocalstore.dart';

// class VerifiedScreen extends StatefulWidget {
//   VerifiedScreen({
//     super.key,
//     required this.imagePath,
//     required this.localstoreId,
//   });
//   final String imagePath;
//   int localstoreId;

//   @override
//   State<VerifiedScreen> createState() => _VerifiedScreenState();
// }

// class _VerifiedScreenState extends State<VerifiedScreen> {
//   var profileId;
//   var tokenId;

//   @override
//   void initState() {
//     super.initState();
//     getString();
//   }

//   void getString() async {
//     var strProfileId = await LocalAuthService().getId();
//     var strToken = await LocalAuthService().getSecureToken();

//     // Verifique se o widget ainda está montado antes de chamar setState
//     if (mounted) {
//       setState(() {
//         tokenId = strToken;
//         profileId = strProfileId;
//       });
//     }
//   }

//   Widget buildImageWidget() {
//     if (kIsWeb) {
//       // Para Flutter Web
//       return Image.network(
//         widget.imagePath,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) {
//           return Center(
//             child: Text("Erro ao carregar imagem."),
//           );
//         },
//       );
//     } else {
//       // Para plataformas móveis
//       return Image.file(
//         File(widget.imagePath),
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) {
//           return Center(
//             child: Text("Erro ao carregar imagem."),
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: lightColor,
//         body: Padding(
//           padding: defaultPaddingHorizon,
//           child: ListView(
//             children: [
//               MainHeader(
//                 title: "Parabéns!",
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     SecundaryText(
//                       text: 'Parabéns pela ótima compra!',
//                       color: nightColor,
//                       align: TextAlign.start,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SubText(
//                       text:
//                           "Iremos validar seu comprovante e, em até 7 dias, se a compra for confirmada, o saldo irá cair na sua conta!",
//                       align: TextAlign.start,
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     SizedBox(
//                       height: 400,
//                       child: buildImageWidget(),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SubText(
//                           text: "A foto não ficou legal?",
//                           align: TextAlign.center,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DocumentScannerScreen(
//                                   localstoreId: widget.localstoreId,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: DefaultButton(
//                             color: SecudaryColor,
//                             padding: const EdgeInsetsDirectional.symmetric(
//                                 vertical: 10, horizontal: 10),
//                             text: "Tirar outra foto",
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         AuthController().uploadImageToStrapi(
//                           token: tokenId,
//                           profileId: profileId,
//                           localStoreId: widget.localstoreId.toString(),
//                           filePath: widget.imagePath,
//                         );
//                       },
//                       child: DefaultButton(
//                         color: FourtyColor,
//                         padding: defaultPadding,
//                         text: "Finalizar",
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
