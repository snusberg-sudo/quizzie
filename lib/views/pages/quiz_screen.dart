import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/models/question.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/data/providers/quiz_answers_state.dart';
import 'package:quizzie/data/providers/quiz_questions_state.dart';
import 'package:quizzie/views/pages/quiz_score.dart';
import 'package:quizzie/views/widgets/choice_tile.dart';
import 'package:quizzie/views/widgets/custom_progress_bar.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final pageController = PageController(keepPage: true);
  int _currentQuestionIndex = 0;
  List alphabeticalIndex = ["A", "B", "C", "D"];
  List<Map> selectedChoices = [];
  PaintingEffect skeletonEffect = PulseEffect(
    from: Colors.grey.shade300,
    to: Colors.grey.shade100,
  );

  @override
  void initState() {
    super.initState();
  }

  void _nextQuestion(int quizLength) {
    if (_currentQuestionIndex < quizLength - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => QuizScore(
                quizId: widget.quiz.id,
                selectedChoices: selectedChoices,
                quizCount: widget.quiz.questionsCount,
              ),
        ),
      );
    }
  }

  String _buttonTextDecider(bool hasChoice, int quizLength) {
    if (_currentQuestionIndex < quizLength - 1) {
      return hasChoice ? "Next" : "Skip";
    }
    return "Finish";
  }

  void _handleChoiceTap(dynamic choiceId) {
    setState(() {
      selectedChoices[_currentQuestionIndex]['choice_id'] = choiceId;
    });
  }

  bool isSelected(
    int questionId,
    dynamic choiceId,
    List<Map<String, dynamic>> selectedAnswers,
  ) {
    return selectedAnswers.any(
      (entry) =>
          entry['question_id'] == questionId && entry['choice_id'] == choiceId,
    );
  }

  bool hasChoice(int questionId, List<Map<String, dynamic>> selectedAnswers) {
    return selectedAnswers.any((entry) => entry['question_id'] == questionId);
  }

  @override
  Widget build(BuildContext context) {
    final quizQuestionsState = ref.watch(quizQuestionsProvider(widget.quiz.id));
    final quizAnswersState = ref.read(quizAnswersProvider.notifier);
    final quizAnswers = ref.watch(quizAnswersProvider);
    final quizQuestions = quizQuestionsState.items;

    final isLoading = quizQuestionsState.isLoading;
    final quizLength = quizQuestionsState.items.length;
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: CustomScrollView(
        shrinkWrap: false,
        slivers: [
          MyAppbar(
            centerTitle: true,
            backgroundColor: Colors.amberAccent.shade400,
            expandedHeight: 130.0,
            collapsedHeight: 60.0,
            title: Text(
              widget.quiz.title,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 18,
                letterSpacing: -0.6,
              ),
            ),
            leading: null,
            automaticallyImplyLeading: false,
            actions: [
              MyActionIconButton(
                icon: FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.black87,
                  size: 18.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                borderRadiusGeometry: BorderRadiusGeometry.circular(50.0),
                borderSide: BorderSide(color: Colors.black54, width: 2),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 20.0,
                      ),
                      child: Skeletonizer(
                        enabled: isLoading,
                        enableSwitchAnimation: true,
                        effect: skeletonEffect,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 7.0,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${(_currentQuestionIndex + 1).toString().padLeft(2, '0')} Question",
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${_currentQuestionIndex + 1} of ${quizQuestionsState.items.length}",
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    wordSpacing: -0.5,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ],
                            ),
                            CustomProgressBar(
                              value:
                                  isLoading
                                      ? 0
                                      : (_currentQuestionIndex + 1) /
                                          quizLength,
                              backgroundColor: Colors.grey.shade300.withValues(
                                alpha: 0.5,
                              ),
                              progressColor: Colors.white,
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: quizLength,
                      controller: pageController,
                      itemBuilder: (context, pageIndex) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.0),
                            Text(
                              !isLoading
                                  ? quizQuestions[pageIndex]['question_text']
                                  : '',
                              style: GoogleFonts.rubik(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Choose your answer",
                              style: GoogleFonts.rubik(
                                fontSize: 14.5,
                                color: Colors.grey.shade100.withValues(
                                  alpha: 0.8,
                                ),
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                primary: true,
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                itemCount:
                                    !isLoading
                                        ? quizQuestions[pageIndex]['choices']
                                            .length
                                        : 4,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final choice =
                                      !isLoading
                                          ? quizQuestions[pageIndex]["choices"][index]
                                          : null;
                                  final isChoice =
                                      !isLoading
                                          ? isSelected(
                                            quizQuestions[pageIndex]['id'],
                                            choice['id'],
                                            quizAnswers,
                                          )
                                          : false;
                                  return ChoiceTile(
                                    alphaChoice: alphabeticalIndex.elementAt(
                                      index,
                                    ),
                                    hasData: !isLoading,
                                    isChoice: isChoice,
                                    choice: choice,
                                    handleTap:
                                        () => _handleChoiceTap(choice['id']),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(35.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55.0,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amberAccent.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.black87, width: 2),
                          ),
                        ),
                        onPressed:
                            !isLoading
                                ? () {
                                  _nextQuestion(quizLength);
                                }
                                : null,
                        child:
                            !isLoading
                                ? Padding(
                                  padding: EdgeInsetsGeometry.only(
                                    right: 10.0,
                                    left: 15.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "", //_buttonTextDecider(hasChoice()),
                                        style: GoogleFonts.rubik(
                                          fontSize: 21.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.chevronRight,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                )
                                : SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    strokeCap: StrokeCap.round,
                                    color: Colors.grey.shade100,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
