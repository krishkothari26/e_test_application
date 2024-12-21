class Question {
  final String category;
  final int id;
  final String questions;  // Corrected to 'questions'
  final List<String> options;
  final int answer;

  Question({
    required this.category,
    required this.id,
    required this.questions, // Corrected to 'questions'
    required this.options,
    required this.answer,
  });

  // Convert to JSON for saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
      'questions': questions, // Corrected to 'questions'
      'options': options,
      'answer': answer,
    };
  }

  // Convert JSON to Question
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json['category'],
      id: json['id'],
      questions: json['questions'],  // Corrected to 'questions'
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }
}
