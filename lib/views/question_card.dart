import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/models/questions_model.dart';
import 'package:e_test_application/utils/constants.dart';
import 'package:e_test_application/views/option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.questions, // Use 'questions' instead of 'text'
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: kBlackColor),
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          ...List.generate(
            question.options.length,
            (index) => Options(
              text: question.options[index],
              index: index,
              press: () => questionController.checkAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
