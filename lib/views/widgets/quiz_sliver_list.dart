import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/views/pages/quiz_confirmation.dart';
import 'package:quizzie/views/widgets/quiz_result_mini.dart';
import 'package:quizzie/views/pages/quiz_result_review.dart';
import 'package:quizzie/views/widgets/refreshable_fallback.dart';
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
      return RefreshableFallback(
        onRefresh: () async {
          await Future.delayed(Duration.zero, () {
            ref.read(quizDataProvider.notifier).refreshData();
          });
        },
        text: 'Error: ${quizDataState.error}',
      );
    } else if (quizItems.isEmpty && !quizDataState.isLoading) {
      return RefreshableFallback(
        onRefresh: () async {
          await Future.delayed(Duration.zero, () {
            ref.read(quizDataProvider.notifier).refreshData();
          });
        },
        text: 'No quizzies found!',
      );
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
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
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
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.grey.shade300.withValues(alpha: 0.35),
                child: ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 15.0,
                    top: 10.0,
                    bottom: 10.0,
                    right: 20.0,
                  ),
                  onTap: () {
                    mode == 'latest'
                        ? showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
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
                  leading: AspectRatio(
                    aspectRatio: 1.0,
                    child:
                        !quizDataState.isLoading
                            ? Container(
                              width: 75.0,
                              height: 75.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: BoxBorder.all(
                                  color: Colors.amberAccent.shade400,
                                  width: 2.5,
                                ),
                                //color: Colors.amberAccent.shade400,
                              ),
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.code,
                                color: Colors.indigoAccent,
                              ),
                            )
                            : Bone.square(
                              borderRadius: BorderRadius.circular(15.0),
                              size: 75.0,
                            ),
                  ),
                  title:
                      !quizDataState.isLoading
                          ? Text(
                            quizTitle!,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.5,
                              letterSpacing: -0.3,
                            ),
                          )
                          : Bone.text(words: 3, fontSize: 17),
                  subtitle:
                      !quizDataState.isLoading
                          ? Text(
                            quizDesc!,
                            style: GoogleFonts.rubik(
                              color: Colors.black38,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: -0.3,
                            ),
                          )
                          : Bone.multiText(fontSize: 12.0, lines: 2),
                  trailing:
                      !quizDataState.isLoading
                          ? QuizResultMini(
                            qaCount: qaCount ?? 0,
                            score: score ?? 0,
                            mode: mode,
                          )
                          : Bone.square(
                            size: 30,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
