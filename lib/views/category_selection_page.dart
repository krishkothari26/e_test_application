import 'package:e_test_application/views/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_test_application/controllers/question_controller.dart';

class CategorySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionController = Get.find<QuestionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Category"),
      ),
      body: ListView.builder(
        itemCount: questionController.savedCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questionController.savedCategories[index]),
            onTap: () {
              // Set filtered questions based on category and start the quiz
              questionController.setFilteredQuestions(questionController.savedCategories[index]);
              Get.to(QuizPage());  // Navigate to the quiz page
            },
          );
        },
      ),
    );
  }
}
