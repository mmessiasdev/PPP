import 'dart:convert';
import 'dart:math';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/model/openvoalleinvoices.dart';
import 'package:Prontas/model/prenatal/consultations.dart';
import 'package:Prontas/model/prenatal/exams.dart';
import 'package:Prontas/model/prenatal/medicines.dart';
import 'package:Prontas/model/prenatal/vaccines.dart';
import 'package:Prontas/model/serasamodel.dart';
import 'package:Prontas/model/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;

import '../../model/categoriescareers.dart';

// const url = String.fromEnvironment('BASEURL', defaultValue: '');

class RemoteAuthService {
  var client = http.Client();
  final storage = FlutterSecureStorage();

  final url = dotenv.env["BASEURL"];

  Future<dynamic> signUp(
      {required String email,
      required String password,
      required String username}) async {
    var body = {"username": username, "email": email, "password": password};
    var response = await client.post(
      Uri.parse('$url/auth/local/register'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    var body = {"identifier": email, "password": password};
    var response = await client.post(
      Uri.parse('$url/auth/local'),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> createProfile({
    required String fullname,
    required String token,
  }) async {
    var body = {
      "fullname": fullname,
    };
    var response = await client.post(
      Uri.parse('$url/profiles/me'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> getProfile({
    required String token,
  }) async {
    // Faz a chamada GET e retorna o objeto Response diretamente
    return await client.get(
      Uri.parse('$url/profiles/me'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true",
      },
    );
  }

  Future addRequests({
    required String? colaboratorname,
    required String? cpf,
    required String? token,
    required String? resultReq,
  }) async {
    final body = {
      "colaboratorname": colaboratorname,
      "cpf": cpf,
      "result": resultReq,
    };
    var response = await client.post(
      Uri.parse('$url/requests'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<List<PrenatalVaccines>> getPrenatalVaccines({
    required String? token,
  }) async {
    List<PrenatalVaccines> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/prenatalvaccines'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(PrenatalVaccines.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<PrenatalMedicines>> getPrenatalMedicines({
    required String? token,
  }) async {
    List<PrenatalMedicines> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/prenatalmedicines'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(PrenatalMedicines.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<PrenatalExams>> getPrnatalExams({
    required String? token,
  }) async {
    List<PrenatalExams> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/prenatalexams'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(PrenatalExams.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future postPrenatalExams(
      {required String? token,
      required String? result,
      required String? type,
      required String? date,
      int? profileId}) async {
    final body = {
      "data": date,
      "type": type,
      "result": result,
      "profile": profileId
    };
    var response = await client.post(
      Uri.parse('$url/prenatalexams'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<List<PrenatalConsultations>> getPrenatalConsultations({
    required String? token,
  }) async {
    List<PrenatalConsultations> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/prenatalconsultations'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(PrenatalConsultations.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<CoursesModel>> getOneCategoryCourse({
    required String? token,
    required String? id,
  }) async {
    List<CoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/category-courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body['courses'];
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<CoursesModel>> getCerfiticatesCourses(
      {required String? token, required String profileId}) async {
    List<CoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse(
          '${url.toString()}/courses?profilescerfiticates.id_eq=$profileId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<Map> getOneCourse({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future<dynamic> putFavoriteCourse({
    required String fullname,
    required String token,
    required String id,
    required String profileId,
  }) async {
    var body = {
      "profilespinned": [profileId],
    };
    var response = await client.put(
      Uri.parse('${url.toString()}/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Curso adicionado aos favoritos!");
    }
    return response;
  }

  Future<List<Videos>> getOneCourseVideos({
    required String? token,
    required String? id,
  }) async {
    List<Videos> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body['videos'];
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(Videos.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<Map> getOneProof({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/proofs/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future<dynamic> putAddCerfiticates({
    required String token,
    required String id,
    required String profileId,
  }) async {
    var body = {
      "profilescerfiticates": [profileId],
    };
    var response = await client.put(
      Uri.parse('${url.toString()}/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<List<CoursesModel>> getFavoriteCourses(
      {required String? token, required String profileId}) async {
    List<CoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/courses?profilespinned.id_eq=$profileId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<Map> getOneVideo({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/videos/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future<List<CoursesModel>> getCourses({
    required String? token,
  }) async {
    List<CoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/courses'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<CategoryCoursesModel>> getCategoriesCourses({
    required String? token,
  }) async {
    List<CategoryCoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/category-courses'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CategoryCoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<CoursesModel>> getCoursesSearch({
    required String token,
    required String query,
  }) async {
    List<CoursesModel> listItens = [];
    var response = await client.get(
      Uri.parse(
          "${url.toString()}/courses?private=false&title_contains=$query"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(CoursesModel.fromJson(itemCount[i]));
    }
    return listItens;
  }
}
