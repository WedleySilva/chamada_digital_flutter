import 'package:flutter/material.dart';
import '../models/attendance_round.dart';

class RoundListItem extends StatelessWidget {
  final AttendanceRound round;
  final VoidCallback onTap;

  const RoundListItem({super.key, required this.round, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: round.statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: round.statusColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              round.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              round.statusText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: round.statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
