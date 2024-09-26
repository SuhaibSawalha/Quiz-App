import 'package:quiz_app/modules/answer.dart';

class Question {
  String title;
  List<Answer> answers;
  int correctAnswer;

  Question(
      {required this.title,
      required this.answers,
      required this.correctAnswer});
}
