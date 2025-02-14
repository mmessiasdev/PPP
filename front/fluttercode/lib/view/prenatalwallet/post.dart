import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  var client = http.Client();
  String? token;
  String? fullname;
  String? profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strFullname = await LocalAuthService().getFullName();
    var strProfileId = await LocalAuthService().getId();

    setState(() {
      token = strToken;
      profileId = strProfileId;
      fullname = strFullname;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController typeField = TextEditingController();
  final TextEditingController dataField = TextEditingController();
  final TextEditingController resultField = TextEditingController();

  TextEditingController salesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Center(
            child: SizedBox(
              width: isDesktop ? 600 : double.infinity,
              child: Padding(
                padding: defaultPaddingHorizon,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: typeField,
                        decoration: InputDecoration(labelText: "Campo 1"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: dataField,
                        decoration: InputDecoration(labelText: "Campo 2"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: resultField,
                        decoration: InputDecoration(labelText: "Campo 3"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          RemoteAuthService().postPrenatalExams(
                            token: token,
                            date: dataField.text,
                            type: typeField.text,
                            result: resultField.text,
                            profileId: int.parse(profileId.toString()),
                          );
                          Navigator.pop(context);
                        },
                        child: DefaultButton(
                          text: "Adicionar",
                          padding: defaultPadding,
                          icon: Icons.check,
                          color: SeventhColor,
                          colorText: lightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
