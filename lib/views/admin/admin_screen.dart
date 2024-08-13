import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/models/questions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;
  AdminScreen({super.key, required this.quizCategory});
  final QuestionController questionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to $quizCategory"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: questionController.questionControllerText,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              TextFormField(
                controller: questionController.optionControllers[0],
                decoration: const InputDecoration(labelText: "Options 1}"),
              ),
              TextFormField(
                controller: questionController.optionControllers[1],
                decoration: const InputDecoration(labelText: "Options 2}"),
              ),
              TextFormField(
                controller: questionController.optionControllers[2],
                decoration: const InputDecoration(labelText: "Options 3}"),
              ),
              TextFormField(
                controller: questionController.optionControllers[3],
                decoration: const InputDecoration(labelText: "Options 4}"),
              ),
              TextFormField(
                controller: questionController.correctAnswerController,
                decoration:
                    const InputDecoration(labelText: "Correct Answer (0-3)"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (questionController.questionControllerText.text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else if (questionController
                      .optionControllers[0].text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else if (questionController
                      .optionControllers[1].text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else if (questionController
                      .optionControllers[2].text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else if (questionController
                      .optionControllers[3].text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else if (questionController
                      .correctAnswerController.text.isEmpty) {
                    Get.snackbar("Required", "All Fields are Required");
                  } else {
                    addQuestions();
                  }
                },
                child: const Text("Add Questions"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addQuestions() async {
    //collecting questions from the text Controllers
    final String questionText = questionController.questionControllerText.text;
    final List<String> options = questionController.optionControllers
        .map((controller) => controller.text)
        .toList();
    final int correctAnswer =
        int.tryParse(questionController.correctAnswerController.text) ?? 1;

    //Creating a new Question Instance
    final Question newQuestion = Question(
      category: quizCategory,
      id: DateTime.now().microsecondsSinceEpoch,
      questions: questionText,
      options: options,
      answer: correctAnswer,
    );

    //Save the question to SharedPreferences
    await questionController.saveQuestionToSharedPreferences(newQuestion);
    Get.snackbar("Added", "Question Added");
    questionController.questionControllerText.clear();
    questionController.optionControllers.forEach((element){
      element.clear();
    });
    questionController.correctAnswerController.clear();
  }
}
