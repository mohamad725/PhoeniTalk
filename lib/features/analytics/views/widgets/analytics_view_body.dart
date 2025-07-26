import 'package:flutter/material.dart';
import 'package:uniapp/features/analytics/data/analytics_dummy_data.dart';
import 'package:uniapp/features/analytics/views/widgets/performance_chart.dart';
import 'package:uniapp/features/analytics/views/widgets/quiz_card.dart';
import 'package:uniapp/features/analytics/views/widgets/summary_card.dart';

class AnalyticsViewBody extends StatefulWidget {
  const AnalyticsViewBody({super.key});

  @override
  State<AnalyticsViewBody> createState() => _AnalyticsViewBodyState();
}

class _AnalyticsViewBodyState extends State<AnalyticsViewBody> {
  int _expandedQuizIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final shadowColor =
        isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    int totalAttempts = quizzes.fold(
      0,
      (sum, q) => sum + (q['attempts'] as int),
    );
    double avgScore =
        quizzes.map((q) => q['averageScore'] as int).reduce((a, b) => a + b) /
        quizzes.length;
    double avgCompletion =
        quizzes
            .map((q) => q['completionRate'] as double)
            .reduce((a, b) => a + b) /
        quizzes.length;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SummaryCard(
              totalAttempts: totalAttempts,
              avgScore: avgScore,
              avgCompletion: avgCompletion,
              isDarkMode: isDarkMode,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: PerformanceChart(
              cardColor: cardColor,
              shadowColor: shadowColor,
              quizzes: quizzes,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Your Quizzes (${quizzes.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final quiz = quizzes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: QuizCard(
                  quiz: quiz,
                  isExpanded: _expandedQuizIndex == index,
                  onTap:
                      () => setState(() {
                        _expandedQuizIndex =
                            _expandedQuizIndex == index ? -1 : index;
                      }),
                  isDarkMode: isDarkMode,
                ),
              );
            }, childCount: quizzes.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
