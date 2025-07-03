import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/data/providers/quiz_bottom_sheet_state.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/data/utils/decider_for_category.dart';
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
              late QuizBottomSheetState quizBottomSheetState;
              if (quizData.isNotEmpty) {
                quizBottomSheetState = ref.watch(
                  quizBSSNotifierProvider(quizData[index]),
                );
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
                                  title: quizBottomSheetState.quizTitle ?? '',
                                  description:
                                      quizBottomSheetState.quizDesc ?? '',
                                  questionsCount:
                                      quizBottomSheetState.qaCount ?? 0,
                                  id:
                                      quizBottomSheetState.quizAssignmentId ??
                                      0,
                                  completedAt:
                                      quizBottomSheetState.completedAt ?? '',
                                  score: quizBottomSheetState.score ?? 0,
                                ),
                              ),
                        )
                        : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => QuizResultReview(
                                  quizId: quizBottomSheetState.quizId ?? 0,
                                  quizTitle:
                                      quizBottomSheetState.quizTitle ?? '',
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
                                DeciderForCategory(category: quizBottomSheetState.category ?? '').decideCategory,
                                color: Colors.indigoAccent,
                                size: 28.0,
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
                            quizBottomSheetState.quizTitle ?? '',
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
                            quizBottomSheetState.quizDesc ?? '',
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
                            qaCount: quizBottomSheetState.qaCount ?? 0,
                            score: quizBottomSheetState.score ?? 0,
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
