import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_test_application/controllers/question_controller.dart';

class QuizPage extends StatelessWidget {
  final QuestionController questionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          if (controller.filteredQuestion.isEmpty) {
            return Center(child: Text("No questions available"));
          }

          final currentQuestion = controller.filteredQuestion[controller.questionNumber.value - 1];

          return PageView.builder(
            controller: controller.pageController,
            itemCount: controller.filteredQuestion.length,
            onPageChanged: (index) {
              controller.updateTheQnNum(index);  // Update question number when page changes
            },
            itemBuilder: (context, index) {
              final currentQuestion = controller.filteredQuestion[index];
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentQuestion.questions, style: TextStyle(fontSize: 24)),  // Question text
                  ...currentQuestion.options.map((option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          controller.checkAns(currentQuestion, currentQuestion.options.indexOf(option));
                        },
                      )).toList(), // Display options
                ],
              );
            },
          );
        },
      ),
    );
  }
}
