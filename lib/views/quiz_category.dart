import 'package:e_test_application/controllers/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuizCategoryScreen extends StatelessWidget {
  QuizCategoryScreen({super.key});

  final QuestionController _questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/bg.svg"),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: _questionController.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.question_answer),
                      Text(_questionController.savedCategories[index]),
                      Text(_questionController.savedSubtitle[index]),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
