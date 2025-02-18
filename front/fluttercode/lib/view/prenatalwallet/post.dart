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
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field2 = TextEditingController();
  final TextEditingController field3 = TextEditingController();

  TextEditingController salesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      field3.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

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
                        controller: field1,
                        decoration: InputDecoration(labelText: "Nome do exame"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field2,
                        decoration: InputDecoration(labelText: "Resultado"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field3,
                        decoration: InputDecoration(labelText: "Data"),
                        readOnly: true, // Impede digitação manual
                        onTap: () => _selectDate(
                            context), // Abre o painel ao clicar no campo
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          RemoteAuthService().postPrenatalExams(
                            token: token,
                            date: field3.text,
                            type: field1.text,
                            result: field2.text,
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

class AddConsultationsScreen extends StatefulWidget {
  const AddConsultationsScreen({super.key});

  @override
  State<AddConsultationsScreen> createState() => _AddConsultationsScreenState();
}

class _AddConsultationsScreenState extends State<AddConsultationsScreen> {
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
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field3 = TextEditingController();
  final TextEditingController field2 = TextEditingController();

  TextEditingController salesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      field3.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

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
                        controller: field1,
                        decoration:
                            InputDecoration(labelText: "Nome do médico"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field2,
                        decoration: InputDecoration(labelText: "Observações"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field3,
                        decoration:
                            InputDecoration(labelText: "Dia da consulta"),
                        readOnly: true, // Impede digitação manual
                        onTap: () => _selectDate(
                            context), // Abre o painel ao clicar no campo
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          RemoteAuthService().postPrenatalConsultations(
                            token: token,
                            date: field3.text,
                            professional: field1.text,
                            obs: field2.text,
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

class AddVaccinesScreen extends StatefulWidget {
  const AddVaccinesScreen({super.key});

  @override
  State<AddVaccinesScreen> createState() => _AddVaccinesScreenState();
}

class _AddVaccinesScreenState extends State<AddVaccinesScreen> {
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
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field3 = TextEditingController();
  final TextEditingController field2 = TextEditingController();

  TextEditingController salesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      field3.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

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
                        controller: field1,
                        decoration:
                            InputDecoration(labelText: "Nome da vacina tomada"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field2,
                        decoration:
                            InputDecoration(labelText: "Proíxima Aplicação"),
                        readOnly: true, // Impede digitação manual
                        onTap: () => _selectDate(
                            context), // Abre o painel ao clicar no campo
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field3,
                        decoration:
                            InputDecoration(labelText: "Dia da aplicação"),
                        readOnly: true, // Impede digitação manual
                        onTap: () => _selectDate(
                            context), // Abre o painel ao clicar no campo
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          RemoteAuthService().postPrenatalVaccines(
                            token: token,
                            date: field3.text,
                            name: field1.text,
                            nextdose: field2.text,
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

class AddMedicinesScreen extends StatefulWidget {
  const AddMedicinesScreen({super.key});

  @override
  State<AddMedicinesScreen> createState() => _AddMedicinesScreenState();
}

class _AddMedicinesScreenState extends State<AddMedicinesScreen> {
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
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field3 = TextEditingController();
  final TextEditingController field2 = TextEditingController();

  TextEditingController salesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      field3.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

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
                        controller: field1,
                        decoration:
                            InputDecoration(labelText: "Nome do medicamento"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field2,
                        decoration: InputDecoration(labelText: "Observações"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      TextFormField(
                        controller: field3,
                        decoration: InputDecoration(labelText: "Dosagem"),
                        validator: (value) =>
                            value!.isEmpty ? "Campo obrigatório" : null,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          RemoteAuthService().postPrenatalMedicines(
                            token: token,
                            name: field1.text,
                            dosage: field3.text,
                            obs: field2.text,
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
