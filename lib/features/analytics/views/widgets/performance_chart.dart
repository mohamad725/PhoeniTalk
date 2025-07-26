import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({
    super.key,
    required this.cardColor,
    required this.shadowColor,
    required this.quizzes,
  });

  final Color cardColor;
  final Color shadowColor;
  final List<Map<String, dynamic>> quizzes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(isVisible: false),
          series: <LineSeries<Map<String, dynamic>, int>>[
            LineSeries<Map<String, dynamic>, int>(
              dataSource: quizzes,
              xValueMapper: (quiz, index) => index,
              yValueMapper: (quiz, _) => quiz['averageScore'],
              name: 'Average Score',
              color: Colors.red,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
