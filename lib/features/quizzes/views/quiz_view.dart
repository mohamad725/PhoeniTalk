import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final List<String> questions = [
    '🗣️ How do you say "Hello" in French?',
    '🏙️ What is the capital of Lebanon?',
    '🍎 Say the color of the apple in English.',
  ];

  int currentPage = 0;
  bool isAnswering = false;

  double get progress => (currentPage + 1) / questions.length;

  void _handleVoiceAnswer() {
    if (isAnswering) return;

    setState(() => isAnswering = true);

    Future.delayed(const Duration(seconds: 2), () {
      final bool correct = currentPage % 2 == 0; // Dummy logic

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            correct ? '✅ Correct!' : '❌ Try again!',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: correct ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      setState(() => isAnswering = false);

      if (correct && currentPage < questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() => currentPage++);
      } else if (correct && currentPage == questions.length - 1) {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("🎉 Quiz Complete!"),
            content: const Text("You've finished all questions."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showExitDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Exit",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox(); // Required but not used
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - curvedValue) * 50),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 48,
                        color: Color(0xFFE53935),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Exit Quiz?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Are you sure you want to exit the quiz? Your progress will be lost.",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Exit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with progress and exit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => _showExitDialog(),
                  ),
                  const Spacer(),
                  Text(
                    'Question ${currentPage + 1}/${questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.red.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryRed),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Column(
                      key: ValueKey(index),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDEAEA),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: primaryRed.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              questions[index],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: primaryRed.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              isAnswering
                                  ? '🎙️ Listening...'
                                  : 'Tap the microphone to answer by voice',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Floating Mic Button
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: FloatingActionButton(
                onPressed: _handleVoiceAnswer,
                backgroundColor: primaryRed,
                child:
                    isAnswering
                        ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                        : const Icon(Icons.mic, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
