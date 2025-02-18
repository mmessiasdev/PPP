import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/view/club/store/online/storescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContentProduct extends StatelessWidget {
  ContentProduct(
      {super.key,
      required this.drules,
      required this.title,
      this.urlThumb,
      this.maxl,
      this.over,
      this.bgcolor,
      required this.id});

  final String drules;
  final String title;
  final String? urlThumb;
  String id;
  int? maxl;
  TextOverflow? over;
  Color? bgcolor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {
            (Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreScreen(id: id)),
            ));
          },
          child: Container(
              width: 150,
              height: 250,
              decoration: BoxDecoration(
                color: bgcolor ?? lightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Image.network(
                          urlThumb ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: FourtyColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubText(
                          color: lightColor,
                          text: drules,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SecundaryText(
                      text: title,
                      color: nightColor,
                      align: TextAlign.start,
                      maxl: maxl,
                      over: over,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}



// import 'package:Prontas/component/colors.dart';
// import 'package:Prontas/component/texts.dart';
// import 'package:Prontas/view/course/coursescreen.dart';
// import 'package:Prontas/view/videos/coursescreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class ContentProduct extends StatelessWidget {
//   ContentProduct(
//       {super.key,
//       required this.drules,
//       required this.title,
//       required this.urlThumb,
//       this.maxl,
//       this.over,
//       this.bgcolor,
//       required this.id});

//   final String? drules;
//   final String? title;
//   final String? urlThumb;
//   String? id;
//   int? maxl;
//   TextOverflow? over;
//   Color? bgcolor;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: GestureDetector(
//         onTap: () {
//           (Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => CoursePayScreen(
//                       id: id ?? "",
//                       urlbanner: urlThumb ?? "",
//                     )),
//           ));
//         },
//         child: Container(
//             width: 150,
//             height: 250,
//             decoration: BoxDecoration(
//               color: bgcolor ?? lightColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 100,
//                       child: Image.network(
//                         urlThumb ?? "",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: FourtyColor,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SubText(
//                         color: lightColor,
//                         text: drules ?? "",
//                         align: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   SecundaryText(
//                     text: title ?? "",
//                     color: nightColor,
//                     align: TextAlign.start,
//                     maxl: maxl,
//                     over: over,
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }
