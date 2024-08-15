import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Options extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;
  const Options(
      {super.key,
      required this.text,
      required this.index,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (controller) {
        Color getTheRightColor() {
          if (controller.isAnswered) {
            if (index == controller.correctAns) {
              return kGreenColor;
            } else if (index == controller.selectedAns &&
                controller.selectedAns != controller.correctAns) {
              return kRedColor;
            }
          }
          return kGrayColor;
        }

        IconData getTheRightIcon() {
          return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
        }

        return GestureDetector(
          onTap: press,
          child: Container(
            margin: EdgeInsets.only(top: kDefaultPadding),
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              border: Border.all(color: getTheRightColor()),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${index + 1}. $text",
                  style: TextStyle(
                    color: getTheRightColor(),
                    fontSize: 16,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: getTheRightColor() == kGrayColor
                        ? Colors.transparent
                        : getTheRightColor(),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getTheRightColor()),
                  ),
                  child: getTheRightColor() == kGrayColor
                      ? null
                      : Icon(
                          getTheRightIcon(),
                          size: 16,
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
