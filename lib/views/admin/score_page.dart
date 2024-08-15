import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/bg.svg",
            fit: BoxFit.fitWidth,
          ),
          Column(
            children: [
              const Spacer(flex: 3,),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: kScondaryColor),
              ),
              Text(
                "${questionController.numOfCorrectAns * 10} / ${questionController.filteredQuestion.length * 10}",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: kScondaryColor),
              ),
              const Spacer(flex: 3,),
            ],
          )
        ],
      ),
    );
  }
}
