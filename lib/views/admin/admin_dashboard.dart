import 'package:e_test_application/controllers/question_controller.dart';
import 'package:e_test_application/views/admin/admin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        backgroundColor: const Color.fromARGB(255, 12, 44, 92),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text("Admin Dashboard"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/bg.svg",
            fit: BoxFit.fitWidth,
          ),
          GetBuilder<QuestionController>(
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.savedCategories.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.black54,
                    child: ListTile(
                      onTap: () {
                        Get.to(AdminScreen(
                            quizCategory: controller.savedCategories[index]));
                      },
                      leading: const Icon(Icons.question_answer),
                      title: Text(
                        controller.savedCategories[index],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      subtitle: Text(
                        controller.savedSubtitle[index],
                        style: TextStyle(fontSize: 10, color: Colors.white38),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Get.snackbar("Uploaded Paper",
                              controller.savedCategories[index]);
                        },
                        icon: const Icon(Icons.upload_outlined),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialogBox() {
    // Define TextEditingControllers for managing input
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();

    Get.defaultDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      titlePadding: const EdgeInsets.only(top: 15),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            controller: categoryController, // Link to the controller
            decoration: const InputDecoration(
              hintText: "Enter the category name",
            ),
          ),
          TextFormField(
            controller: subtitleController, // Link to the controller
            decoration: const InputDecoration(
              hintText: "Enter the category subtitle",
            ),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        // Extract data from controllers
        String categoryName = categoryController.text.trim();
        String categorySubtitle = subtitleController.text.trim();

        if (categoryName.isNotEmpty && categorySubtitle.isNotEmpty) {
          // Pass data to the controller for saving
          questionController.savedQuestionCategoryToSharedPreferences(
            categoryName,
            categorySubtitle,
          );

          // Close the dialog
          Get.back();
        } else {
          // Show an error message if fields are empty
          Get.snackbar(
            "Error",
            "Both fields are required!",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}
