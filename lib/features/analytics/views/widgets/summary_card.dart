import 'package:flutter/material.dart';
import 'package:uniapp/features/analytics/views/widgets/summary_stat.dart';

class SummaryCard extends StatelessWidget {
  final int totalAttempts;
  final double avgScore;
  final double avgCompletion;
  final bool isDarkMode;

  const SummaryCard({
    super.key,
    required this.totalAttempts,
    required this.avgScore,
    required this.avgCompletion,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0 : 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SummaryStat(
                value: '$totalAttempts',
                label: 'Total Attempts',
                icon: Icons.assignment_turned_in,
                color: Colors.blue,
                isDarkMode: isDarkMode,
              ),
              SummaryStat(
                value: '${avgScore.toStringAsFixed(1)}%',
                label: 'Avg. Score',
                icon: Icons.star,
                color: Colors.amber,
                isDarkMode: isDarkMode,
              ),
              SummaryStat(
                value: '2m 5s',
                label: 'Time',
                icon: Icons.timer_outlined,
                color: Colors.green,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: avgCompletion,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getCompletionColor(avgCompletion),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                '${(avgCompletion * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCompletionColor(double value) {
    if (value > 0.8) return Colors.green;
    if (value > 0.6) return Colors.amber;
    return Colors.red;
  }
}
