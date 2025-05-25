import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/views/pages/quiz_confirmation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizSliverList extends StatelessWidget {
  const QuizSliverList({
    super.key,
    required this.snapshot,
    required this.onRefresh,
  });

  final AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData &&
        snapshot.connectionState != ConnectionState.waiting) {
      return Center(child: Text('No quizzes found.'));
    } else {
      List<Map<dynamic, dynamic>> quizData = [];
      String? quizTitle, quizDesc;
      int? quizAssignmentId, qaCount;
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        quizData = snapshot.data!;
      }
      return Skeletonizer(
        enabled: snapshot.connectionState == ConnectionState.waiting,
        effect: PulseEffect(
          from: Colors.grey.shade300,
          to: Colors.grey.shade100,
        ),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            itemCount: snapshot.hasData ? snapshot.data!.length : 4,
            itemBuilder: (context, index) {
              if (quizData.isNotEmpty) {
                quizAssignmentId = quizData[index]['quiz']['id'];
                quizTitle = quizData[index]['quiz']['title'];
                quizDesc = quizData[index]['quiz']['description'];
                qaCount = quizData[index]['quiz']['questions_count'];
              }
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      builder:
                          (context) => QuizConfirmation(
                            quiz: Quiz(
                              title: quizTitle ?? '',
                              description: quizDesc ?? '',
                              questionsCount: qaCount ?? 0,
                              id: quizAssignmentId ?? 0,
                            ),
                          ),
                    );
                  },
                  title:
                      quizData.isNotEmpty
                          ? Text(
                            quizTitle!,
                            style: GoogleFonts.robotoFlex(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          )
                          : Bone.text(words: 3, fontSize: 17),
                  subtitle:
                      quizData.isNotEmpty
                          ? Text(
                            quizDesc!,
                            style: GoogleFonts.robotoFlex(
                              color: Colors.black38,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          )
                          : Bone.text(words: 4, fontSize: 14.0),
                  trailing:
                      quizData.isNotEmpty
                          ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.indigoAccent.withValues(
                                  alpha: 0.2,
                                ),
                                width: 4.25,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 18.0,
                              foregroundColor: Colors.indigoAccent,
                              backgroundColor: Colors.white24,
                              child: Text(
                                qaCount.toString(),
                                style: GoogleFonts.robotoFlex(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                          )
                          : Bone.circle(size: 36),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
