import 'package:Prontas/component/buttons.dart';
import 'package:Prontas/component/colors.dart';
import 'package:Prontas/component/padding.dart';
import 'package:Prontas/component/texts.dart';
import 'package:Prontas/component/tips.dart';
import 'package:Prontas/component/widgets/header.dart';
import 'package:Prontas/model/balancelocalstores.dart';
import 'package:Prontas/model/verifiquedexitbalances.dart';
import 'package:Prontas/service/local/auth.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/view/club/wallet/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String screen = "saldo";
  var token;
  var fullname;
  var cpf;
  var id;
  final _formKey = GlobalKey<FormState>();
  String? urlEnv = dotenv.env["BASEURL"];

  TextEditingController valueExit = TextEditingController();

  @override
  void dispose() {
    valueExit.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getString();
  }

  // Recuperar as informações de autenticação armazenadas
  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strFullName = await LocalAuthService().getFullName();
    var strProfileId = await LocalAuthService().getId();

    if (mounted) {
      setState(() {
        // cpf = strCpf.toString();
        id = strProfileId.toString();
        fullname = strFullName.toString();
        token = strToken.toString();
      });
    }
  }

// Função assíncrona para calcular o saldo total
  Future<double> calculateTotalBalance({
    required String? token,
    required String? profileId,
  }) async {
    try {
      // Obter as entradas de saldo (BalanceLocalStores)
      List<BalanceLocalStores> balanceLocalStores = await RemoteAuthService()
          .getBalanceLocalStores(token: token, profileId: profileId);

      // Obter as saídas de saldo (VerfiquedExitBalances)
      List<VerfiquedExitBalances> exitBalances = await RemoteAuthService()
          .getExitBalances(token: token, profileId: profileId);

      double balanceSum = 0.0;
      double exitSum = 0.0;

      // Somar os valores de balance (tratando valores nulos e inválidos)
      for (var balance in balanceLocalStores) {
        // Usar tryParse para evitar exceções em caso de valor inválido
        double? value = double.tryParse(balance.value.toString());
        if (value != null) {
          balanceSum += value;
        } else {
          print("Valor inválido encontrado em balance: ${balance.value}");
        }
      }

      // Somar os valores de exit (tratando valores nulos e inválidos)
      for (var exit in exitBalances) {
        // Usar tryParse para evitar exceções em caso de valor inválido
        double? value = double.tryParse(exit.value.toString());
        if (value != null) {
          exitSum += value;
        } else {
          print("Valor inválido encontrado em exit: ${exit.value}");
        }
      }

      // Calcular o total
      return balanceSum - exitSum;
    } catch (e) {
      // Capturar exceções mais gerais
      print("Erro ao calcular o saldo: $e");
      return 0.0; // Retorna 0 em caso de erro
    }
  }

  void _showDraggableScrollableSheet(BuildContext context) {
    TextEditingController pixKeyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPadding,
                    child: SecundaryText(
                      text: "Selecione o valor que você deseja retirar",
                      color: nightColor,
                      align: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: defaultPadding,
                          child: InputTextField(
                            textEditingController: valueExit,
                            title: "R\$",
                            fcolor: SecudaryColor,
                            fill: true,
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter(),
                            ],
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '0,00') {
                                return 'Insira um valor válido.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: defaultPadding,
                          child: InputTextField(
                            textEditingController: pixKeyController,
                            title: "Chave Pix",
                            fcolor: SecudaryColor,
                            fill: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'A chave Pix é obrigatória.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: defaultPadding,
                    child: Tips(
                      desc:
                          "Sua solicitação de retirada passará por uma verificação e dentro de 3 dias o saldo estará na chave Pix adicionada!",
                    ),
                  ),
                  Padding(
                    padding: defaultPadding,
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          String rawValue = valueExit.text
                              .replaceAll('.', '')
                              .replaceAll(',', '.');

                          double? exitValueDouble = double.tryParse(rawValue);

                          if (exitValueDouble != null) {
                            if (currentBalanceDoublePrint > exitValueDouble) {
                              try {
                                bool success = await _getExitBalanceVerifiqued(
                                  value: exitValueDouble.toString(),
                                  id: int.parse(id),
                                  token: token.toString(),
                                  bankkey: pixKeyController.text,
                                );

                                if (success) {
                                  Navigator.of(Get.overlayContext!)
                                      .pushReplacementNamed('/');

                                  EasyLoading.showSuccess(
                                      "Solicitação de retirada feita com sucesso! Aguarde algumas horas.");
                                } else {
                                  EasyLoading.showError(
                                      "Falha na transferência.");
                                }
                              } catch (e) {
                                print("Erro na transferência: $e");
                                EasyLoading.showError(
                                    "Erro ao processar a retirada.");
                              }
                            } else {
                              EasyLoading.showError("Saldo insuficiente.");
                            }
                          } else {
                            EasyLoading.showError("Valor inválido.");
                          }
                        }
                      },
                      child: DefaultButton(
                        text: "Retirar",
                        padding: defaultPadding,
                        color: SeventhColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Função simulada para buscar detalhes da chave Pix
  Future<Map<String, String>> _fetchPixDetails(String pixKey) async {
    // Substitua por sua integração real
    await Future.delayed(Duration(seconds: 2)); // Simula um tempo de resposta
    return {
      "name": "João da Silva",
      "bank": "Banco do Brasil",
    };
  }

// Função para realizar o POST para a API do Mercado Pago usando chave PIX
  Future<bool> _getExitBalanceVerifiqued(
      {required int id,
      required String token,
      required String value,
      required String bankkey}) async {
    // URL para a API do Mercado Pago
    final String url = '$urlEnv/verfiqued-exit-balances';

    // Substitua pelo token de acesso real do Mercado Pago (obtido via OAuth ou credenciais)
    final String accessToken = token;

    try {
      // Fazendo a requisição POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "value": "$value",
          "approved": "false",
          "profile": "$id",
          "bankkey": bankkey
        },
      );

      if (response.statusCode == 200) {
        // Sucesso na transferência
        print("Transferência realizada com sucesso!");
        return true;
      } else {
        // Erro ao processar a transferência
        print("Algo deu errado: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro ao chamar a API Interna: $e");
      return false;
    }
  }

  String currentBalance = "";
  double currentBalanceDouble = 0;
  double currentBalanceDoublePrint = 0.0;

  bool _isActivated = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: defaultPaddingHorizon,
            child: MainHeader(
              title: "Carteira",
              onClick: () {},
            ),
          ),
          // O total de saldo é exibido diretamente pelo FutureBuilder
          SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: defaultPaddingHorizon,
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizonTop,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Saldo",
                            style: TextStyle(
                              color:
                                  screen == "saldo" ? nightColor : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              screen = "saldo";
                            });
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            "Extrato",
                            style: TextStyle(
                              color: screen == "extract"
                                  ? nightColor
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              screen = "extract";
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  screen == "saldo"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            FutureBuilder<double>(
                              future: calculateTotalBalance(
                                  token: token, profileId: id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return SecundaryText(
                                      text:
                                          'Erro ao calcular saldo: ${snapshot.error}',
                                      color: nightColor,
                                      align: TextAlign.start);
                                } else if (snapshot.hasData) {
                                  currentBalanceDoublePrint = snapshot.data ??
                                      0.0; // Aqui inicializa a variável
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SubText(
                                        text: 'Saldo disponível:',
                                        color: nightColor,
                                        align: TextAlign.start,
                                      ),
                                      SecundaryText(
                                        text:
                                            'R\$${currentBalanceDoublePrint.toStringAsFixed(2)}',
                                        color: nightColor,
                                        align: TextAlign.start,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text('Nenhum dado encontrado');
                                }
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            // BankCard(
                            //   cpf: cpf ?? "",
                            //   name: fullname ?? "",
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            Tips(
                              desc:
                                  "Após a compra de algum produto dentro do link do nosso app, o valor do cashback leva no máximo até 7 dias uteis para ser acrescentado na sua conta.",
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDraggableScrollableSheet(context);
                              },
                              child: DefaultButton(
                                color: nightColor,
                                colorText: lightColor,
                                text: "Resgatar saldo",
                                padding: EdgeInsets.all(20),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: defaultPadding,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SecundaryText(
                                        text: "Entradas",
                                        color: nightColor,
                                        align: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Switch(
                                        value:
                                            _isActivated, // Valor do switch (true ou false)
                                        onChanged: (bool newValue) {
                                          // Atualiza o estado quando o usuário muda a posição do switch
                                          setState(() {
                                            _isActivated = newValue;
                                          });
                                        },
                                        activeColor:
                                            FifthColor, // Cor do switch quando ativado
                                        inactiveThumbColor:
                                            SeventhColor, // Cor do thumb quando desativado
                                        activeTrackColor: OffColor,
                                        inactiveTrackColor:
                                            PrimaryColor, // Cor da trilha quando desativado
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      // Texto indicando o estado atual
                                      SecundaryText(
                                          text: 'Saídas',
                                          color: nightColor,
                                          align: TextAlign.center)
                                    ],
                                  ),
                                  _isActivated == false
                                      ? EnterBalancesScreen(
                                          token: token,
                                          id: id,
                                        )
                                      : ExitBalancesScreem(
                                          token: token,
                                          id: id,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String title;
  final Color fcolor;
  final bool fill;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator; // Adicionando o parâmetro

  InputTextField({
    required this.textEditingController,
    required this.title,
    required this.fcolor,
    required this.fill,
    this.textInputType,
    this.inputFormatters,
    this.validator, // Aceitar validação
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: title,
        filled: fill,
        fillColor: fcolor,
      ),
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      validator: validator, // Aplicar validação no TextFormField
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove caracteres indesejados
    String numericString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Converte o valor para formato monetário
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    double numericValue = double.parse(numericString) / 100;
    String formattedText = formatter.format(numericValue);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
