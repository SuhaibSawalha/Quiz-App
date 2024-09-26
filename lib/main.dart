import 'package:flutter/material.dart';
import 'package:quiz_app/modules/question.dart';
import 'package:quiz_app/modules/answer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  List<Question> questions = [
    Question(
        title: "what's the capital of Palestine ?",
        answers: [
          Answer(text: "Ramallah", icon: Icons.location_city),
          Answer(text: "Nablus", icon: Icons.location_city),
          Answer(text: "Jerusalem", icon: Icons.location_city),
          Answer(text: "Tulkarm", icon: Icons.location_city),
        ],
        correctAnswer: 2),
    Question(
      title: "what's the religion of Palestine ?",
      answers: [
        Answer(text: "Islam", icon: Icons.mosque),
        Answer(text: "Christianity", icon: Icons.church),
        Answer(text: "Judaism", icon: Icons.synagogue),
        Answer(text: "Buddhism", icon: Icons.bungalow),
      ],
      correctAnswer: 0,
    ),
    Question(
        title: "what are the colors of the Palestinian flag ?",
        answers: [
          Answer(text: "red, green, white, blue", icon: Icons.color_lens),
          Answer(text: "red, white, black", icon: Icons.color_lens),
          Answer(text: "white, green, black", icon: Icons.color_lens),
          Answer(text: "red, black, white, green", icon: Icons.color_lens),
        ],
        correctAnswer: 3)
  ];
  int currentQuestionIndex = 0, seeAnswers = 0;
  List<int> userAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Quiz App"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: currentQuestionIndex < questions.length
                  ? questionBox(questions[currentQuestionIndex])
                  : seeAnswers == 1
                      ? displayAnswers()
                      : displayResult()),
        ));
  }

  Widget questionBox(Question question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question.title,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Text(
              "question ${currentQuestionIndex + 1} of ${questions.length}",
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.start),
        ),
        Column(
            children: question.answers
                .map((answer) =>
                    choiceBox(question, question.answers.indexOf(answer)))
                .toList()),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    if (currentQuestionIndex > 0) {
                      currentQuestionIndex--;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentQuestionIndex == 0
                          ? Colors.red[200]
                          : Colors.red[400]),
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text("Previous"),
                )),
            InkWell(
                onTap: () {
                  setState(() {
                    if (currentQuestionIndex < userAnswers.length) {
                      currentQuestionIndex++;
                    }
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentQuestionIndex >= userAnswers.length
                            ? Colors.green[200]
                            : Colors.green[500]),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    height: 50,
                    child: Text(currentQuestionIndex == questions.length - 1
                        ? "Finish"
                        : "Next"))),
          ],
        )
      ],
    );
  }

  Widget choiceBox(Question question, int index) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
          onTap: answerQuestion(index),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (userAnswers.length > currentQuestionIndex &&
                        index == userAnswers[currentQuestionIndex])
                    ? Colors.green
                    : Colors.grey[200],
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(question.answers[index].icon),
                    const SizedBox(width: 10),
                    Text(question.answers[index].text,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ))),
    );
  }

  void Function() answerQuestion(int answerIndex) {
    return () {
      setState(() {
        if (userAnswers.length <= currentQuestionIndex) {
          userAnswers.add(answerIndex);
        } else {
          userAnswers[currentQuestionIndex] = answerIndex;
        }
      });
    };
  }

  Widget displayResult() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == userAnswers[i]) {
        score++;
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        score <= 1
            ? resultText("Try Harder", Colors.red)
            : score == 2
                ? resultText("Good Job", Colors.orange)
                : resultText("Great", Colors.green),
        Text("you scored $score/${questions.length}",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
              onTap: () {
                setState(() {
                  currentQuestionIndex = 0;
                  userAnswers = [];
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple[400]),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: 50,
                  child: const Text("Reset Quiz",
                      style: TextStyle(color: Colors.white, fontSize: 16)))),
          InkWell(
              onTap: () {
                setState(() {
                  seeAnswers = 1;
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green[400]),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: 50,
                  child: const Text("See Answers",
                      style: TextStyle(color: Colors.white, fontSize: 16))))
        ])
      ],
    );
  }

  Widget resultText(String text, Color textColor) {
    return Text(text, style: TextStyle(fontSize: 30, color: textColor));
  }

  Widget displayAnswers() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...questions.map((question) => questionWithAnswers(question)).toList(),
        InkWell(
            onTap: () {
              setState(() {
                seeAnswers = 0;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                child: const Text("Back",
                    style: TextStyle(color: Colors.white, fontSize: 16))))
      ],
    ));
  }

  Widget questionWithAnswers(Question question) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 231, 228, 228),
      ),
      child: Column(
        children: [
          Text(
            question.title,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
              children: question.answers
                  .map((answer) => answerBox(
                      question,
                      questions.indexOf(question),
                      question.answers.indexOf(answer)))
                  .toList()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget answerBox(Question question, int questionIndex, int index) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (question.correctAnswer == index)
                ? Colors.green
                : (userAnswers[questionIndex] == index)
                    ? Colors.red
                    : Colors.grey[200],
          ),
          width: double.infinity,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(question.answers[index].icon),
                const SizedBox(width: 10),
                Text(question.answers[index].text,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          )),
    );
  }
}
