import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/texts.dart';
import 'package:flutter/material.dart';

class CategorieClub extends StatelessWidget {
  CategorieClub(
      {super.key, required this.title, this.illurl, required this.id});

  String title;
  String? illurl;
  String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        // onTap: () {
        //   (Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CategoryScreenCareers(
        //               id: id,
        //             )),
        //   ));
        // },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                width: 150,
                height: 220,
                illurl ?? "",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SubText(
                  text: title, align: TextAlign.start, color: nightColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorieCareers extends StatelessWidget {
  CategorieCareers(
      {super.key, required this.title, this.illurl, required this.id});

  String title;
  String? illurl;
  String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        // onTap: () {
        //   (Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CategoryScreenCareers(id: id))));
        // },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                width: 150,
                height: 220,
                illurl ?? "",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SubText(
                  text: title, align: TextAlign.start, color: nightColor),
            ),
          ],
        ),
      ),
    );
  }
}
