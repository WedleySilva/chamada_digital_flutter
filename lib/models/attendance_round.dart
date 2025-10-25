import 'package:flutter/material.dart';

enum AttendanceStatus { pendente, presente, ausente }

class AttendanceRound {
  final String id;
  final String title;
  AttendanceStatus status;
  DateTime? recordedAt;

  AttendanceRound({
    required this.id,
    required this.title,
    this.status = AttendanceStatus.pendente,
    this.recordedAt,
  });

  // Cor do card baseada no status
  Color get statusColor {
    switch (status) {
      case AttendanceStatus.presente:
        return Colors.green.shade600;
      case AttendanceStatus.ausente:
        return Colors.red.shade600;
      case AttendanceStatus.pendente:
      default:
        return Colors.orange.shade600;
    }
  }

  // Texto do status
  String get statusText {
    switch (status) {
      case AttendanceStatus.presente:
        return 'Presente';
      case AttendanceStatus.ausente:
        return 'Ausente';
      case AttendanceStatus.pendente:
      default:
        return 'Pendente';
    }
  }
}
