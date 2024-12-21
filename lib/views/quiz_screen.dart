import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/views/body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizScreen extends StatelessWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Initialize the QuestionController and filter questions by category
    final questionController = Get.put(QuestionController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionController.setFilteredQuestions(
          category); // Filter questions after frame rendering
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: $category'), // Dynamic title
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          // Ensure the filtered questions are set before rendering
          if (controller.filteredQuestion.isEmpty) {
            return const Center(
              child: Text('No questions available for this category.'),
            );
          }
          return const Body(); // Render the Body widget
        },
      ),
    );
  }
}
