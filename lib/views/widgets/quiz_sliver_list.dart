import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/views/pages/quiz_confirmation.dart';
import 'package:quizzie/views/widgets/quiz_count_circle.dart';
import 'package:quizzie/views/widgets/quiz_result_review.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizSliverList extends ConsumerWidget {
  const QuizSliverList({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDataState = ref.watch(quizDataProvider);
    final quizItems = ref.watch(
      mode == "latest" ? latestQuizProvider : historyQuizProvider,
    );

    if (quizDataState.error != null) {
      return Center(child: Text('Error: ${quizDataState.error}'));
    } else if (quizItems.isEmpty && !quizDataState.isLoading) {
      return Center(child: Text('No quizzes found.'));
    } else {
      List<dynamic> quizData = [];
      String? quizTitle, quizDesc, completedAt;
      int? quizAssignmentId, qaCount, score, quizId;
      if (quizItems.isNotEmpty) {
        quizData = quizItems;
      }
      return Skeletonizer(
        enabled: quizDataState.isLoading,
        effect: PulseEffect(
          from: Colors.grey.shade300,
          to: Colors.grey.shade100,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration.zero, () {
              ref.read(quizDataProvider.notifier).refreshData();
            });
          },
          child: ListView.builder(
            primary: false,
            shrinkWrap: false,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 20),
            itemCount: quizItems.isNotEmpty ? quizItems.length : 4,
            itemBuilder: (context, index) {
              if (quizData.isNotEmpty) {
                quizId = quizData[index]['id'];
                quizAssignmentId = quizData[index]['quiz']['id'];
                quizTitle = quizData[index]['quiz']['title'];
                quizDesc = quizData[index]['quiz']['description'];
                qaCount = quizData[index]['quiz']['questions_count'];
                completedAt = quizData[index]['completed_at'];
                score = quizData[index]['score'];
              }
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  onTap: () {
                    mode == 'latest'
                        ? showModalBottomSheet(
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
                                  completedAt: completedAt ?? '',
                                  score: score ?? 0,
                                ),
                              ),
                        )
                        : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => QuizResultReview(
                                  quizId: quizId ?? 0,
                                  quizTitle: quizTitle ?? '',
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
                          ? QuizCountCircle(
                            qaCount: qaCount ?? 0,
                            score: score ?? 0,
                            mode: mode,
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
