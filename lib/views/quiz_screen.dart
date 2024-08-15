import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/views/body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuestionController questionController = Get.put(QuestionController());
  @override
  void initState() {
    questionController.setFilteredQuestions(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: questionController.nextQuestion,
              child: const Text("Skip"))
        ],
      ),
      body: const Body(),
    );
  }
}
