import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import '../models/attendance_round.dart';
import '../screens/my_code_screen.dart';
import '../screens/validation_flow_screen.dart';
import '../widgets/round_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<AttendanceRound> _rounds;

  @override
  void initState() {
    super.initState();
    _loadMockRounds();
  }

  void _loadMockRounds() {
    _rounds = [
      AttendanceRound(id: '1', title: 'Aula (19:00 - 20:00)'),
      AttendanceRound(id: '2', title: 'Aula (20:00 - 21:00)'),
      AttendanceRound(id: '3', title: 'Aula (21:00 - 22:00)'),
      AttendanceRound(id: '4', title: 'Aula (22:00 - 22:30)'),
    ];
  }

  void _startValidation(AttendanceRound round) async {
    if (round.status != AttendanceStatus.pendente) return;

    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ValidationFlowScreen(round: round)),
    );

    if (result == true) {
      setState(() {
        round.status = AttendanceStatus.presente;
        round.recordedAt = DateTime.now();
      });
    }
  }

  Future<void> _generateCsv() async {
    final rows = [
      ["Matéria", "Data", "Horário"],
      ["BANCO DE DADOS", "2025-11-20", "19:05"],
      ["PROBABILIDADE E ESTATÍSTICA", "2025-11-21", "19:10"],
      ["PROGRAMAÇÃO SERVER-SIDE", "2025-11-22", "20:02"],
      ["SOFT SKILLS - EMPREENDEDORISMO, CRIATIVIDADE E INOVAÇÃO", "2025-11-23", "18:59"],
      ["TESTE DE SOFTWARE", "2025-11-24", "19:15"],
      ["PROJETO DE APRENDIZAGEM COLABORATIVA EXTENSIONISTA III - PAC ESOFT", "2025-11-25", "20:22"],
    ];

    final csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/historico_chamadas.csv");
    await file.writeAsString(csv);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV gerado como historico_chamadas.csv")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chamada Automática'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rounds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final round = _rounds[index];
                return RoundListItem(
                  round: round,
                  onTap: () => _startValidation(round),
                );
              },
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            /// HISTÓRICO SIMPLES (SEM ARRAY)
            const Text(
              "Histórico de Presenças",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("BANCO DE DADOS"),
                subtitle: Text("Registrado em: 20/11/2025 às 19:05"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("PROBABILIDADE E ESTATÍSTICA"),
                subtitle: Text("Registrado em: 21/11/2025 às 19:10"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("PROGRAMAÇÃO SERVER-SIDE"),
                subtitle: Text("Registrado em: 22/11/2025 às 20:02"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("SOFT SKILLS - EMPREENDEDORISMO, CRIATIVIDADE E INOVAÇÃO"),
                subtitle: Text("Registrado em: 23/11/2025 às 18:59"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("TESTE DE SOFTWARE"),
                subtitle: Text("Registrado em: 24/11/2025 às 19:15"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            const SizedBox(height: 8),

            const Card(
              elevation: 2,
              child: ListTile(
                title: Text("PROJETO DE APRENDIZAGEM COLABORATIVA EXTENSIONISTA III - PAC ESOFT"),
                subtitle: Text("Registrado em: 25/11/2025 às 20:22"),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton.icon(
                onPressed: _generateCsv,
                icon: const Icon(Icons.file_download),
                label: const Text("Baixar Relatório CSV"),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCodeScreen()),
          );
        },
        icon: const Icon(Icons.qr_code_2_rounded),
        label: const Text('Meu Código'),
      ),
    );
  }
}
