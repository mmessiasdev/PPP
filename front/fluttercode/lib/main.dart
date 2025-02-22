import 'package:Prontas/component/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:Prontas/route/route.dart';
import 'package:Prontas/route/page.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// flutter run --release

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Retrato normal
    DeviceOrientation.portraitDown // Retrato invertido (se necessário)
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: lightColor, // cor da barra superior
    statusBarIconBrightness: Brightness.light, // ícones da barra superior
    systemNavigationBarColor: PrimaryColor, // cor da barra inferior
    systemNavigationBarIconBrightness:
        Brightness.light, // ícones da barra inferior
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPage.list,
      initialRoute: AppRoute.dashboard,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      theme: ThemeData(fontFamily: 'Montserrat'),
    );
  }
}
