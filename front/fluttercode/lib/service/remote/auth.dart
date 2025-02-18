import 'dart:convert';
import 'dart:math';
import 'package:Prontas/model/balancelocalstores.dart';
import 'package:Prontas/model/carrouselbanners.dart';
import 'package:Prontas/model/courses.dart';
import 'package:Prontas/model/localstores.dart';
import 'package:Prontas/model/localstoresverfiquedbuy.dart';
import 'package:Prontas/model/openvoalleinvoices.dart';
import 'package:Prontas/model/planstores.dart';
import 'package:Prontas/model/prenatal/consultations.dart';
import 'package:Prontas/model/prenatal/exams.dart';
import 'package:Prontas/model/prenatal/medicines.dart';
import 'package:Prontas/model/prenatal/vaccines.dart';
import 'package:Prontas/model/serasamodel.dart';
import 'package:Prontas/model/stores.dart';
import 'package:Prontas/model/verifiquedexitbalances.dart';
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

  
  Future<List<Banners>> getCarrouselBanners({
    required String? token,
    required String? id,
  }) async {
    List<Banners> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/carrousels/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body['banners'];
    print(itemCount);
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(Banners.fromJson(itemCount[i]));
    }
    return listItens;
  }
    Future<List<StoresModel>> getStores({
    required String? token,
  }) async {
    List<StoresModel> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/online-stores'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(StoresModel.fromJson(itemCount[i]));
    }
    return listItens;
  }

    Future<Map> getStore({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/online-stores/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
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

  Future<List<LocalStores>> getOnePlansLocalStores({
    required String? token,
    required String? id,
  }) async {
    List<LocalStores> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/plans/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body["local_stores"];
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(LocalStores.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<LocalStores>> getLocalStores({
    required String? token,
  }) async {
    List<LocalStores> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/local-stores'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(LocalStores.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<PlanStores>> getPlanStores(
      {required String? token, required String? id}) async {
    List<PlanStores> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/plans/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body["plan_stores"];
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(PlanStores.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<Map> getLocalStore({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/local-stores/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future<Map> getQrCodeLocalStore({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/local-stores/$id/qrcode'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future<List<Receipt>> getVerifiquedLocalStoriesFiles(
      {required String? token, required String? id}) async {
    List<Receipt> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/verifiqued-buy-local-stores/${id}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body["receipt"];
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(Receipt.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<BalanceLocalStores>> getBalanceLocalStores(
      {required String? token, required String? profileId}) async {
    List<BalanceLocalStores> listItens = [];

    var response = await client.get(
      Uri.parse(
          '${url.toString()}/verifiqued-buy-local-stores?profile.id_eq=${profileId}&approved=true'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(BalanceLocalStores.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<List<VerfiquedExitBalances>> getExitBalances(
      {required String? token, required String? profileId}) async {
    List<VerfiquedExitBalances> listItens = [];
    var response = await client.get(
      Uri.parse(
          '${url.toString()}/verfiqued-exit-balances?profile.id_eq=${profileId}&approved=true'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    print(body);
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(VerfiquedExitBalances.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future postExitBalances(
      {required String? token,
      required String? profileId,
      required String? valueExit}) async {
    final body = {
      "value": valueExit.toString(),
      "profile": [profileId]
    };
    var response = await client.post(
      Uri.parse('${url.toString()}/verfiqued-exit-balances'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Saldo enviado para conta de destino!");
      Navigator.of(Get.overlayContext!).pushReplacementNamed('/');
    } else {
      EasyLoading.showSuccess("Algo deu errado. Tente novamente!");
    }
    return response;
  }

  Future<List<StoresModel>> getOnlineStoresSearch({
    required String token,
    required String query,
  }) async {
    List<StoresModel> listItens = [];
    var response = await client.get(
      Uri.parse("${url.toString()}/online-stores?name_contains=$query"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(StoresModel.fromJson(itemCount[i]));
    }
    return listItens;
  }
}
