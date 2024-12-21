import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_test_application/controllers/question_controller.dart';

class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting the controller
    final questionController = Get.find<QuestionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Score"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz Finished!",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              "You answered ${questionController.numOfCorrectAns} out of ${questionController.questions.length} correctly.",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Optionally, navigate back to the quiz start page or category selection
                Get.back();
              },
              child: Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
