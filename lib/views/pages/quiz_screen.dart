import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/models/question.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/views/pages/quiz_score.dart';
import 'package:quizzie/views/widgets/choice_tile.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  bool _hasError = false;
  List alphabeticalIndex = ["A", "B", "C", "D"];
  List<Map> selectedChoices = [];
  PaintingEffect skeletonEffect = PulseEffect(
    from: Colors.grey.shade300,
    to: Colors.grey.shade100,
  );

  @override
  void initState() {
    super.initState();
    _getQuestions();
  }

  Future<void> _getQuestions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final apiService = ApiService();
    try {
      final response = await apiService.get(
        '/user/quiz-assignments/${widget.quiz.id}/questions',
      );
      _questions = response.data['data'][0]['quiz']['questions'];
      selectedChoices =
          _questions.map((question) {
            return {"question_id": question["id"], "choice_id": null};
          }).toList();
    } catch (error) {
      _hasError = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
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

  String _buttonTextDecider(bool hasChoice) {
    if (_currentQuestionIndex < _questions.length - 1) {
      return hasChoice ? "Next" : "Skip";
    }
    return "Finish";
  }

  void _handleChoiceTap(dynamic choiceId) {
    setState(() {
      selectedChoices[_currentQuestionIndex]['choice_id'] = choiceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasData = !_isLoading && _questions.isNotEmpty;
    final question = hasData ? _questions[_currentQuestionIndex] : null;
    final hasChoice =
        hasData &&
        (selectedChoices[_currentQuestionIndex]['choice_id'] != null);
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: CustomScrollView(
        slivers: [
          MyAppbar(
            centerTitle: true,
            backgroundColor: Colors.amberAccent.shade400,
            expandedHeight: 130.0,
            title: Text(
              widget.quiz.title,
              style: GoogleFonts.inter(
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
                        enabled: _isLoading,
                        enableSwitchAnimation: true,
                        effect: skeletonEffect,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 7.0,
                          children: [
                            LinearProgressIndicator(
                              trackGap: 6.0,
                              value:
                                  _isLoading
                                      ? 0
                                      : (_currentQuestionIndex + 1) /
                                          _questions.length,
                              minHeight: 8.5,
                              backgroundColor: Colors.grey.shade300.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(25.0),
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${_currentQuestionIndex + 1}",
                                    style: GoogleFonts.robotoFlex(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/${_questions.length}",
                                    style: GoogleFonts.robotoFlex(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
          SliverPadding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                hasData ? question['question_text'] : '',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Choose your answer",
                style: GoogleFonts.inter(
                  color: Colors.grey.shade100.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Skeletonizer(
                effect: skeletonEffect,
                enabled: _isLoading,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  itemCount: hasData ? question['choices'].length : 4,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final choice = hasData ? question["choices"][index] : null;
                    final isChoice =
                        (hasData &&
                                _currentQuestionIndex < selectedChoices.length)
                            ? selectedChoices[_currentQuestionIndex]['choice_id'] ==
                                choice['id']
                            : false;
                    return ChoiceTile(
                      alphaChoice: alphabeticalIndex.elementAt(index),
                      hasData: hasData,
                      isChoice: isChoice,
                      choice: choice,
                      handleTap: () => _handleChoiceTap(choice['id']),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 0),
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
                          !_isLoading
                              ? () {
                                _nextQuestion();
                              }
                              : null,
                      child:
                          !_isLoading
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
                                      _buttonTextDecider(hasChoice),
                                      style: GoogleFonts.inter(
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
        ],
      ),
    );
  }
}
