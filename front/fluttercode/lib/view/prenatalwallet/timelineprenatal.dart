import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:Prontas/service/remote/auth.dart';
import 'package:Prontas/model/prenatal/consultations.dart';
import 'package:Prontas/model/prenatal/exams.dart';
import 'package:Prontas/model/prenatal/vaccines.dart';
import 'package:Prontas/service/local/auth.dart';

class PrenatalTimelineScreen extends StatefulWidget {
  const PrenatalTimelineScreen({super.key});

  @override
  State<PrenatalTimelineScreen> createState() => _PrenatalTimelineScreenState();
}

class _PrenatalTimelineScreenState extends State<PrenatalTimelineScreen> {
  String? token;
  List<PrenatalConsultations> consultations = [];
  List<PrenatalExams> exams = [];
  List<PrenatalVaccines> vaccines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    token = await LocalAuthService().getSecureToken();

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var consultationsData =
          await RemoteAuthService().getPrenatalConsultations(token: token!);
      var examsData = await RemoteAuthService().getPrnatalExams(token: token!);
      var vaccinesData =
          await RemoteAuthService().getPrenatalVaccines(token: token!);

      setState(() {
        consultations = consultationsData ?? [];
        exams = examsData ?? [];
        vaccines = vaccinesData ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carteira de Pré-Natal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar para a tela de adicionar item
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Consultas"),
                  _buildTimeline(
                      consultations, Icons.calendar_today, "Consulta"),
                  _buildSectionTitle("Exames"),
                  _buildTimeline(exams, Icons.assignment, "Exame"),
                  _buildSectionTitle("Vacinas"),
                  _buildTimeline(vaccines, Icons.medical_services, "Vacina"),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTimeline(List<dynamic> items, IconData icon, String type) {
    if (items.isEmpty) {
      return Center(
        child: Text("Nenhum item disponível para $type."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.5,
          isFirst: index == 0,
          isLast: index == items.length - 1,
          beforeLineStyle: const LineStyle(
            color: Colors.blue,
            thickness: 2,
          ),
          indicatorStyle: IndicatorStyle(
            width: 30,
            height: 30,
            indicator: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
          startChild: _buildTimelineChild(item, type),
          endChild: _buildTimelineDetails(item, type),
        );
      },
    );
  }

  Widget _buildTimelineChild(dynamic item, String type) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type == "Consulta"
                ? item.professional ?? "Profissional não informado"
                : type == "Exame"
                    ? item.type ?? "Tipo não informado"
                    : item.name ?? "Nome não informado",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            type == "Consulta"
                ? item.data ?? "Data não informada"
                : type == "Exame"
                    ? item.data ?? "Data não informada"
                    : item.date ?? "Data não informada",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDetails(dynamic item, String type) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (type == "Consulta") ...[
            Text("Observações: ${item.obs ?? "Nenhuma observação"}"),
          ],
          if (type == "Exame") ...[
            Text("Resultado: ${item.result ?? "Nenhum resultado"}"),
          ],
          if (type == "Vacina") ...[
            Text("Próxima dose: ${item.nextdose ?? "Não informada"}"),
          ],
        ],
      ),
    );
  }
}
