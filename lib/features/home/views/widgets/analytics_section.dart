import 'package:flutter/material.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  final List<Map<String, dynamic>> quizData = const [
    {"title": "Quiz 1", "status": "Completed", "time": "5m 32s", "errors": 2},
    {"title": "Quiz 2", "status": "Failed", "time": "3m 10s", "errors": 6},
    {"title": "Quiz 3", "status": "Completed", "time": "7m 45s", "errors": 1},
  ];

  Color getStatusColor(String status) {
    return status == "Completed" ? Colors.green : Colors.redAccent;
  }

  String getStatusLabel(String status) {
    return status == "Completed" ? "Success" : "Failed";
  }

  IconData getStatusIcon(String status) {
    return status == "Completed"
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text(
            "Recent Analytics",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),

        const SizedBox(height: 12),
        ListView.builder(
          itemCount: quizData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemBuilder: (context, index) {
            final quiz = quizData[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent.shade200,
                          Colors.redAccent.shade700,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                quiz['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    quiz['status'],
                                  ).withValues(alpha: .15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      getStatusIcon(quiz['status']),
                                      color: getStatusColor(quiz['status']),
                                      size: 13,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      getStatusLabel(quiz['status']),
                                      style: TextStyle(
                                        color: getStatusColor(quiz['status']),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                quiz['time'],
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.error_outline,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 1),
                              Text(
                                "${quiz['errors']} error${quiz['errors'] == 1 ? '' : 's'}",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
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
          },
        ),
      ],
    );
  }
}
