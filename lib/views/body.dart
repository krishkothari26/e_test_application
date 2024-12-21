import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/utils/constants.dart';
import 'package:e_test_application/views/progress_bar.dart';
import 'package:e_test_application/views/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find() to get the controller
    QuestionController questionController = Get.find<QuestionController>();
    PageController pageController = questionController.pageController;
    if (questionController.filteredQuestion.isEmpty) {
      return Center(
          child:
              Text("Loading...")); // Show a loading state until data is ready
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          "assets/bg.svg",
          fit: BoxFit.fitWidth,
        ),
        SafeArea(
          child: Column(
            children: [
              ProgressBar(),
              Obx(
                () => Text.rich(
                  TextSpan(
                    text: "Question ${questionController.questionNumber.value}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: kScondaryColor),
                    children: [
                      TextSpan(
                        text: "/${questionController.questions.length}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: kScondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1.5,
              ),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: questionController.updateTheQnNum,
                  itemCount: questionController.questions.length,
                  controller: questionController.pageController,
                  itemBuilder: (context, index) {
                    return QuestionCard(
                        question: questionController.questions[index]);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
