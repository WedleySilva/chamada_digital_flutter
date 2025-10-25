import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chamada Automática'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
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
