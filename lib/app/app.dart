import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniapp/features/quizzes/views/quiz_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
      home: QuizView(),
    );
  }
}


