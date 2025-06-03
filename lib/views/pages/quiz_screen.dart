import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/data/providers/quiz_answers_state.dart';
import 'package:quizzie/data/providers/quiz_questions_state.dart';
import 'package:quizzie/views/pages/quiz_score.dart';
import 'package:quizzie/views/widgets/custom_progress_bar.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:quizzie/views/widgets/quiz_screen_page_view.dart';
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
  PaintingEffect skeletonEffect = PulseEffect(
    from: Colors.white.withValues(alpha: 0.1),
    to: Colors.white.withValues(alpha: 0.3),
  );

  @override
  void initState() {
    super.initState();
  }

  void _nextQuestion(
    int quizLength,
    List<Map<String, dynamic>> selectedChoices,
  ) {
    if (_currentQuestionIndex < quizLength - 1) {
      setState(() {
        pageController.nextPage(
          duration: Duration(milliseconds: 900),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => QuizScore(
                quizId: widget.quiz.id,
                selectedChoices: selectedChoices,
                quizCount: widget.quiz.questionsCount,
              ),
          transitionDuration: Duration(milliseconds: 650),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, -1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
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

  bool hasChoice(int questionId, List<Map<dynamic, dynamic>> selectedAnswers) {
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
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          MyAppbar(
            centerTitle: true,
            backgroundColor: Colors.amberAccent.shade400,
            expandedHeight: 130.0,
            collapsedHeight: 60.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(35.0),
              ),
              side: BorderSide(color: Colors.black87, width: 1.5),
            ),
            title: Hero(
              tag: "quiz_title",
              child: Text(
                widget.quiz.title,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: -0.6,
                ),
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
                minS: Size(40, 40),
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
          SliverToBoxAdapter(
            child: Skeletonizer(
              effect: skeletonEffect,
              enabled: isLoading,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child:
                    isLoading
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15.0),
                              Bone.text(fontSize: 20),
                              SizedBox(height: 20.0),
                              Bone.text(fontSize: 12),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.only(bottom: 17.5),
                                      color: Colors.grey.shade300.withValues(
                                        alpha: 0.35,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Bone.circle(size: 26.0),
                                        title: Bone.multiText(
                                          lines: 2,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: 4,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          children: [
                            Expanded(
                              child: QuizScreenPageView(
                                quizLength: quizLength,
                                pageController: pageController,
                                currentQuestionIndex: _currentQuestionIndex,
                                quizQuestions: quizQuestions,
                                quizAnswers: quizAnswers,
                                isLoading: isLoading,
                                onSelectAnswer: (questionId, choiceId) {
                                  quizAnswersState.selectAnswer(
                                    questionId,
                                    choiceId,
                                  );
                                },
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentQuestionIndex = index;
                                  });
                                },
                                alphabeticalIndex: alphabeticalIndex,
                                hasChoice: hasChoice,
                                isSelected: isSelected,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(35.0),
              child: SizedBox(
                width: double.infinity,
                height: 55.0,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amberAccent.shade400,
                    maximumSize: Size(double.infinity, 55.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black87, width: 2),
                    ),
                  ),
                  onPressed:
                      !isLoading
                          ? () {
                            _nextQuestion(quizLength, quizAnswers);
                          }
                          : () {},
                  child:
                      !isLoading
                          ? Padding(
                            padding: EdgeInsetsGeometry.only(
                              right: 10.0,
                              left: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _buttonTextDecider(
                                    isLoading
                                        ? false
                                        : hasChoice(
                                          quizQuestions.isNotEmpty
                                              ? quizQuestions[_currentQuestionIndex]['id']
                                              : 0,
                                          quizAnswers,
                                        ),
                                    quizLength,
                                  ),
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
                              color: Colors.white,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
