import 'dart:convert'; // Para trabalhar com JSON
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCodeScannerPage extends StatefulWidget {
  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isLoading = false;
  var dataResult; // Para armazenar os dados da API
  var token;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission(); // Verifica a permissão ao iniciar

    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();

    setState(() {
      token = strToken.toString();
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Se estiver carregando, não faz outra requisição
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        // Exemplo: O QR Code pode conter um URL ou um ID
        String apiUrl =
            scanData.code.toString(); // Pode ser um link direto ou ID

        try {
          var response = await http.get(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
              'ngrok-skip-browser-warning': "true"
            },
          );

          if (response.statusCode == 200) {
            EasyLoading.showSuccess('QR Code válido.');

            // Decodifica o JSON da resposta
            var jsonData = jsonDecode(response.body);

            // Atualiza o estado com os valores obtidos da API
            setState(() {
              dataResult = jsonData;
              isLoading = false;
            });
          } else {
            EasyLoading.showError('Erro ao carregar dados.');
            setState(() {
              dataResult = "Erro ao carregar dados da API";
              isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            EasyLoading.showError('QR Code válido não encontrado.');
            dataResult = "Falha na conexão: $e";
            isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await _requestCameraPermission();
    } else if (status.isGranted) {
      // Permissão concedida
      setState(() {});
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {}); // Atualiza a interface para usar o scanner
    } else if (status.isPermanentlyDenied) {
      EasyLoading.showError(
          'Permissão para a câmera negada permanentemente. Vá para as configurações e ative a permissão.');
    } else {
      EasyLoading.showInfo('Permissão negada. O scanner não funcionará.');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: FutureBuilder(
            future: Permission.camera.status,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data == PermissionStatus.granted) {
                return Padding(
                  padding: defaultPaddingHorizon,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MainHeader(
                        title: "Verifique o QR Code",
                        onClick: () {
                          (Navigator.pop(context));
                        },
                        icon: Icons.arrow_back_ios,
                        maxl: 2,
                        over: TextOverflow.fade,
                      ),
                      SizedBox(
                        height: 350,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator() // Mostra o loading
                              : dataResult != null &&
                                      dataResult is Map &&
                                      dataResult.containsKey("id")
                                  ? Padding(
                                      padding: defaultPaddingVertical,
                                      child: ListView(
                                        children: [
                                          Padding(
                                            padding: defaultPaddingVertical,
                                            child: Icon(
                                              Icons.verified,
                                              color: SeventhColor,
                                              size: 40,
                                            ),
                                          ),
                                          SecundaryText(
                                            align: TextAlign.start,
                                            color: nightColor,
                                            text: dataResult?["name"]
                                                    .toString() ??
                                                "",
                                          ),
                                          SubText(
                                              text: dataResult?["localization"]
                                                      .toString() ??
                                                  "",
                                              align: TextAlign.start),
                                          Padding(
                                            padding: defaultPadding,
                                            child: Divider(),
                                          ),
                                          SubTextSized(
                                            text: dataResult?["rules"]
                                                    .replaceAll(
                                                        "\\n", "\n\n") ??
                                                "",
                                            size: 15,
                                            fontweight: FontWeight.w600,
                                            color: OffColor,
                                          )
                                        ],
                                      ),
                                    )
                                  : dataResult != null && dataResult != Map
                                      ? Column(
                                          children: [
                                            Icon(
                                              Icons.dangerous,
                                              color: FifthColor,
                                              size: 40,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SecundaryText(
                                                text: "QR Code inválido.",
                                                color: nightColor,
                                                align: TextAlign.center),
                                          ],
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: PrimaryColor,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SecundaryText(
                                                text: 'Escaneie um QR Code',
                                                color: nightColor,
                                                align: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'Permissão para usar a câmera foi negada.',
                    style: TextStyle(fontSize: 16, color: nightColor),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }),
      ),
    );
  }
}
