import 'package:flutter/material.dart';
import '../models/attendance_round.dart';

class ValidationFlowScreen extends StatefulWidget {
  final AttendanceRound round;
  const ValidationFlowScreen({super.key, required this.round});

  @override
  State<ValidationFlowScreen> createState() => _ValidationFlowScreenState();
}

class _ValidationFlowScreenState extends State<ValidationFlowScreen> {
  bool _isLocationVerified = false;
  bool _isColleagueVerified = false;
  bool _isLocationLoading = false;
  bool _isScanning = false;

  void _simulateLocationCheck() async {
    setState(() => _isLocationLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLocationVerified = true;
      _isLocationLoading = false;
    });
  }

  void _simulateColleagueScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isColleagueVerified = true;
      _isScanning = false;
    });
  }

  void _confirmPresence() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _isLocationVerified && _isColleagueVerified;

    return Scaffold(
      appBar: AppBar(title: Text('Registrar ${widget.round.title}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStep(
              title: 'Passo 1: Verificação de Localização',
              subtitle: 'Simula a checagem se você está na sala.',
              isLoading: _isLocationLoading,
              isDone: _isLocationVerified,
              onPressed: _simulateLocationCheck,
              buttonText: 'Verificar Localização',
            ),
            const SizedBox(height: 24),
            _buildStep(
              title: 'Passo 2: Verificação de Colega',
              subtitle: 'Simula o scan do celular de um colega.',
              isLoading: _isScanning,
              isDone: _isColleagueVerified,
              onPressed: _simulateColleagueScan,
              buttonText: 'Escanear Colega',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: canConfirm ? _confirmPresence : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canConfirm ? Colors.green.shade700 : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Confirmar Presença',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isLoading,
    required bool isDone,
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDone ? Colors.green.shade700 : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 12),
                if (isLoading) const LinearProgressIndicator(),
                if (!isLoading && !isDone)
                  ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (isDone) Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 30),
        ],
      ),
    );
  }
}
