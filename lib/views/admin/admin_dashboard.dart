import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/views/admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    questionController.loadQuestionCategoryFromSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(AdminScreen(
                        quizCategory: controller.savedCategories[index]));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(controller.savedCategories[index]),
                  subtitle: Text(controller.savedSubtitle[index]),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialogBox() {
    Get.defaultDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        titlePadding: const EdgeInsets.only(top: 15),
        title: "Add Quiz",
        content: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter the category name",
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter the category subtitle",
              ),
            ),
          ],
        ),
        textConfirm: "Create",
        textCancel: "Cancel",
        onConfirm: () {
          questionController.savedQuestionCategoryToSharedPreferences();
          Get.back();
        });
  }
}
