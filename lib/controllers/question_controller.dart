import 'dart:convert';

import 'package:e_test_application/models/questions_model.dart';
import 'package:e_test_application/views/admin/score_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //User Interface Codes
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  late PageController _pageController;
  PageController get pageController => _pageController;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAns => _selectedAns;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  List<Question> _questions = [];
  List<Question> get questions => _questions;

  List<Question> _filteredQuestion = [];
  List<Question> get filteredQuestion => _filteredQuestion;
  final TextEditingController questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  Future<void> saveQuestionToSharedPreferences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];

    //Convert the questions list to save it into SharedPreferences
    questions.add(jsonEncode(question.toJson()));
    await prefs.setStringList("questions", questions);
  }

  //Admin Dashboard
  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void savedQuestionCategoryToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(categoryTitleController.text);
    savedSubtitle.add(categorySubtitleController.text);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList((_subtitleKey), savedSubtitle);

    categorySubtitleController.clear();
    categoryTitleController.clear();
    Get.snackbar("Saved", "Category created successfully");
  }

  void loadQuestionCategoryFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];

    savedCategories.assignAll(categories);
    savedSubtitle.assignAll(subtitles);
    update();
  }

  void loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions") ?? [];

    _questions = questionJson
        .map((json) => Question.fromJson(jsonDecode(json)))
        .toList();
    update();
  }

  List<Question> getQustionByCategory(String category) {
    return _questions
        .where((question) => question.category == category)
        .toList();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = false;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;
    _animationController.stop();
    update();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        nextQuestion();
      },
    );
  }

  void nextQuestion() async {
    if (_questionNumber.value != filteredQuestion.length) {
      _isAnswered = false;

      _pageController.nextPage(
        duration: const Duration(microseconds: 250),
        curve: Curves.ease,
      );

      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(const ScorePage());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }

  void setFilteredQuestions(String category) {
    _filteredQuestion = getQustionByCategory(category);
    _questionNumber.value = 1;
    update();
    nextQuestion();
  }

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(
        () => update,
      );
    _animationController.forward().whenComplete(nextQuestion);
    loadQuestionCategoryFromSharedPreferences();
    loadQuestionsFromSharedPreferences();
    _pageController = PageController();
    update();

    super.onInit();
  }
}
