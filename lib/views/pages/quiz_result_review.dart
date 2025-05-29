import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/providers/quiz_result_review_state.dart';
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
  num currentPage = 0;

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
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.indigoAccent.shade700.withValues(alpha: 0.2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  border: BoxBorder.all(color: Colors.indigoAccent, width: 1.5),
                ),
                child:
                    quizResultState.isLoading
                        ? Bone.text(words: 6, fontSize: 17)
                        : Text(
                          quiz['question_text'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            letterSpacing: -0.6,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ReviewChoiceTile(
                      isSkipped: quiz['user_choice_id'] == null,
                      isChoice:
                          quiz['user_choice_id'] ==
                          quiz['choices'][index]['id'],
                      seeExplanation: () {},
                      choice: quiz['choices'][index],
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 18.5,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.quizTitle,
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20.0),
          child: Column(
            children: [
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Question",
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: (currentPage + 1).toString(),
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigoAccent,
                      ),
                      children: [
                        TextSpan(
                          text: '/${quizResultState.items.length}',
                          style: GoogleFonts.inter(
                            fontSize: 24.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: PageView.builder(
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
                          color: Colors.indigoAccent,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.indigoAccent,
                            size: 14.0,
                          ),
                          Text(
                            "Previous",
                            style: GoogleFonts.inter(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.w600,
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
                        minimumSize: Size(double.infinity, 45.0),
                        side: BorderSide(
                          color: Colors.indigoAccent,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Next",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.0,
                              letterSpacing: -0.2,
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.chevronRight, size: 14.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,)
            ],
          ),
        ),
      ),
    );
  }
}
