import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/views/widgets/choice_tile.dart';

class QuizScreenPageView extends StatelessWidget {
  final int quizLength;
  final PageController pageController;
  final int currentQuestionIndex;
  final List<dynamic> quizQuestions;
  final List<Map<String, dynamic>> quizAnswers;
  final bool isLoading;
  final Function(int questionId, int? choiceId) onSelectAnswer;
  final Function(int newIndex) onPageChanged;
  final List alphabeticalIndex;
  final bool Function(
    int questionId,
    List<Map<String, dynamic>> selectedChoices,
  )
  hasChoice;
  final bool Function(
    int questionId,
    int choiceId,
    List<Map<String, dynamic>> selectedChoices,
  )
  isSelected;

  const QuizScreenPageView({
    super.key,
    required this.quizLength,
    required this.pageController,
    required this.currentQuestionIndex,
    required this.quizQuestions,
    required this.quizAnswers,
    required this.isLoading,
    required this.onSelectAnswer,
    required this.onPageChanged,
    required this.alphabeticalIndex,
    required this.hasChoice,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: quizLength,
      controller: pageController,
      onPageChanged: (value) {
        final currentQuestionId =
            quizQuestions.isNotEmpty
                ? quizQuestions[currentQuestionIndex]['id']
                : 0;

        if (!hasChoice(currentQuestionId, quizAnswers)) {
          onSelectAnswer(currentQuestionId, null);
        }
        onPageChanged(value);
      },
      itemBuilder: (context, pageIndex) {
        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double value = 1.0;
            if (pageController.position.haveDimensions) {
              value = (pageController.page! - pageIndex).abs();
              value = (1 - (value.clamp(0.0, 1.0)));
            }
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.98 + (value * 0.02),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0),
                Text(
                  !isLoading ? quizQuestions[pageIndex]['question_text'] : '',
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
                    color: Colors.grey.shade100.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    itemCount:
                        !isLoading
                            ? quizQuestions[pageIndex]['choices'].length
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
                        alphaChoice: alphabeticalIndex.elementAt(index),
                        hasData: !isLoading,
                        isChoice: isChoice,
                        choice: choice,
                        handleTap: () {
                          final qid =
                              quizQuestions.isNotEmpty
                                  ? quizQuestions[currentQuestionIndex]['id']
                                  : -1;
                          onSelectAnswer(qid, choice['id']);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
