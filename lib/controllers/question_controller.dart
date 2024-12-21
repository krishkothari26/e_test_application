import 'dart:convert';

import 'package:e_test_application/models/questions_model.dart';
import 'package:e_test_application/views/admin/score_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation Controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  // Page Controller
  late PageController _pageController;
  PageController get pageController => _pageController;

  // State Variables
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

  // SharedPreferences Keys and Controllers
  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  List<String> savedCategories = [];
  List<String> savedSubtitle = [];

  // UI Text Controllers
  final TextEditingController questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Initialize Animation Controller
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() => update());

    // Initialize PageController
    _pageController = PageController();

    // Load data from SharedPreferences
    loadQuestionCategoryFromSharedPreferences();
    loadQuestionsFromSharedPreferences();

    // Notify UI
    update();
  }

  @override
  void onClose() {
    _pageController.dispose();
    _animationController.dispose();
    super.onClose();
  }

  // SharedPreferences Methods
  Future<void> saveQuestionToSharedPreferences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];
    questions.add(jsonEncode(question.toJson()));
    await prefs.setStringList("questions", questions);
  }

  Future<void> loadQuestionCategoryFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedCategories = prefs.getStringList('categories')?.toList() ?? [];
    savedSubtitle = prefs.getStringList('subtitles')?.toList() ?? [];
    update();
  }

  void loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions") ?? [];
    _questions = questionJson
        .map((json) => Question.fromJson(jsonDecode(json))) // Deserialize
        .toList();

    print("All Questions Loaded: $_questions");
    update(); // Notify UI to refresh
  }

// Save categories to SharedPreferences
  void savedQuestionCategoryToSharedPreferences(
      String categoryName, String categorySubtitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Update in-memory lists
    savedCategories.add(categoryName);
    savedSubtitle.add(categorySubtitle);

    // Save to SharedPreferences
    await prefs.setStringList('categories', savedCategories);
    await prefs.setStringList('subtitles', savedSubtitle);

    print("Saved Categories: $savedCategories");
    print("Saved Subtitles: $savedSubtitle");

    update(); // Notify UI to update
  }

  // Question Management
  List<Question> getQustionByCategory(String category) {
    return _questions
        .where((question) =>
            question.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  void setFilteredQuestions(String category) {
    _filteredQuestion =
        getQustionByCategory(category); // Get questions by category

    if (_filteredQuestion.isEmpty) {
      print("No questions found for this category: $category");
    } else {
      print("Filtered Questions: $_filteredQuestion");
    }

    _questionNumber.value = 1; // Reset the question number
    _isAnswered = false; // Reset answer state
    update();

    if (_filteredQuestion.isNotEmpty) {
      _animationController.reset();
      _animationController.forward();
      _pageController = PageController(); // Reinitialize
      _pageController.jumpToPage(0); // Reset to the first question
    }
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value < _filteredQuestion.length) {
      _isAnswered = false;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(() => ScorePage());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }
}
