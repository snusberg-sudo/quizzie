import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/models/question.dart';
import 'package:quizzie/data/models/quiz.dart';
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
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Quiz Finished"),
              content: Text("You've completed the quiz."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasData = !_isLoading && _questions.isNotEmpty;
    final question = !_isLoading ? _questions[_currentQuestionIndex] : null;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MyAppbar(
            centerTitle: true,
            expandedHeight: 130.0,
            title: Text(
              widget.quiz.title,
              style: GoogleFonts.robotoFlex(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 22.5,
              ),
            ),
            leading: IconButton(
              onPressed: () {},
              color: Colors.white,
              iconSize: 19.0,
              icon: FaIcon(FontAwesomeIcons.chevronLeft),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "Skip",
                  style: GoogleFonts.robotoFlex(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
                        effect: ShimmerEffect(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          duration: Duration(seconds: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 7.0,
                          children: [
                            LinearProgressIndicator(
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
                                Radius.circular(20.0),
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                Colors.indigoAccent,
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                hasData ? question['question_text'] : '',
                style: GoogleFonts.inter(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Skeletonizer(
                enabled: _isLoading,
                child: ListView.builder(
                  itemCount: hasData ? question['choices'].length : 4,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final choice = hasData ? question["choices"][index] : null;
                    return Card(
                      color: Colors.indigoAccent.shade200.withValues(
                        alpha: 0.85,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        title: Text(
                          hasData ? choice["choice_text"] : "",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
