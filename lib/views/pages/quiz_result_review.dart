import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/data/providers/quiz_result_review_state.dart';
import 'package:quizzie/views/styles/common_skeleton_paint.dart';
import 'package:quizzie/views/widgets/review_choice_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizResultReview extends ConsumerStatefulWidget {
  const QuizResultReview({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  final int quizId;
  final String quizTitle;

  @override
  ConsumerState<QuizResultReview> createState() => _QuizResultReviewState();
}

class _QuizResultReviewState extends ConsumerState<QuizResultReview> {
  final pageController = PageController(keepPage: true);
  List<String> alphabeticalIndex = ["A", "B", "C", "D"];
  num currentPage = 0;

  String answerCheck(Map<dynamic, dynamic> quiz) {
    if (quiz.containsKey("user_choice_id")) {
      final choices = quiz['choices'];
      if (choices is List) {
        for (int i = 0; i < choices.length; i++) {
          if (choices[i]['id'] == quiz['user_choice_id']) {
            return choices[i]['is_correct'] ? "正解" : "不正解";
          }
        }
      }
      return "";
    } else {
      return "スキップ";
    }
  }

  late List<dynamic> results;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quizResultState = ref.watch(quizResultReviewProvider(widget.quizId));

    Widget buildQuizResult(Map<dynamic, dynamic> quiz, int index) {
      return Skeletonizer(
        enabled: quizResultState.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.amberAccent.shade400,
                  border: BoxBorder.all(color: Colors.black87),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  answerCheck(quiz),
                  style: GoogleFonts.rubik(
                    color: Colors.black87,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.amberAccent.shade400,
                  borderRadius: BorderRadius.circular(25.0),
                  border: BoxBorder.all(color: Colors.black87, width: 1.25),
                ),
                child:
                    quizResultState.isLoading
                        ? Bone.text(words: 6, fontSize: 17)
                        : Text(
                          quiz['question_text'],
                          style: GoogleFonts.rubik(
                            fontSize: 24,
                            letterSpacing: -0.6,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: ListView.builder(
                  primary: false,
                  itemBuilder: (context, index) {
                    return ReviewChoiceTile(
                      isSkipped: quiz['user_choice_id'] == null,
                      isChoice:
                          quiz['user_choice_id'] ==
                          quiz['choices'][index]['id'],
                      seeExplanation: () {},
                      choice: quiz['choices'][index],
                      alphaIndex: alphabeticalIndex.elementAt(index),
                    );
                  },
                  itemCount: quiz['choices'].length ?? 4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> buildCustomSkeleton() {
      return [
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Bone.text(fontSize: 26.0, words: 2)],
        ),
        SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Bone.text(fontSize: 15.5, words: 1)],
        ),
        SizedBox(height: 25.0),
        Card(
          shadowColor: Colors.grey.shade50.withValues(alpha: 0.2),
          margin: EdgeInsets.only(bottom: 11.5),
          color: Colors.blueGrey[50]!.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(title: Bone.multiText(fontSize: 22, lines: 2)),
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.grey.shade50.withValues(alpha: 0.2),
                margin: EdgeInsets.only(bottom: 17.5),
                color: Colors.blueGrey[50]!.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ListTile(
                  leading: Bone.circle(size: 26.0),
                  title: Bone.multiText(lines: 2, fontSize: 16.0),
                ),
              );
            },
            itemCount: 4,
          ),
        ),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        leadingWidth: 80.0,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0),
            width: 50.0,
            height: 50.0,
            child: IconButton.outlined(
              onPressed: () {
                ref.read(quizDataProvider.notifier).refreshData();
                if (context.mounted) {
                  Navigator.of(context).maybePop();
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 18.0,
              ),
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 0.85),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.indigoAccent,
        title: Text(
          widget.quizTitle,
          style: GoogleFonts.rubik(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20.0),
          child: Skeletonizer(
            effect: skeletonEffect,
            enabled: quizResultState.isLoading,
            child: Column(
              children:
                  quizResultState.isLoading
                      ? buildCustomSkeleton()
                      : [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Question",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 26.0,
                                letterSpacing: -0.5,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: (currentPage + 1).toString(),
                                style: GoogleFonts.rubik(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: '/${quizResultState.items.length}',
                                    style: GoogleFonts.rubik(
                                      fontSize: 24.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Expanded(
                          child: PageView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final quiz = quizResultState.items[index];
                              return buildQuizResult(quiz, index);
                            },
                            itemCount: quizResultState.items.length,
                            controller: pageController,
                            onPageChanged: (value) {
                              setState(() {
                                currentPage = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          spacing: 20.0,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: Duration(milliseconds: 450),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 45.0),
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 0.85,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.chevronLeft,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                    Text(
                                      "Previous",
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  pageController.nextPage(
                                    duration: Duration(milliseconds: 450),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 45.0),
                                  side: BorderSide(
                                    color: Colors.indigoAccent,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Next",
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.chevronRight,
                                      size: 14.0,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
            ),
          ),
        ),
      ),
    );
  }
}
