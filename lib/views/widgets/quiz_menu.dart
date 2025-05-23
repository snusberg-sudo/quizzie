import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/data/models/quiz.dart';
import 'package:quizzie/views/pages/quiz_confirmation.dart';
import 'package:quizzie/views/pages/quiz_screen.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:quizzie/views/widgets/quiz_menu_tab.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key, required this.name});

  final String? name;

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  bool _isLoading = true;
  Future<List<Map<dynamic, dynamic>>> getQuizzies() async {
    final apiService = ApiService();
    try {
      final response = await apiService.get('/user/quiz-assignments');
      print(response.data['data']);
      return List<Map<dynamic, dynamic>>.from(response.data['data']);
    } catch (error) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder(
      future: getQuizzies(),
      builder: (context, snapshot) {
        List<Widget> slivers = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          slivers.add(
            SliverPadding(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Skeletonizer(
                    enabled:
                        snapshot.connectionState == ConnectionState.waiting,
                    justifyMultiLineText: true,
                    effect: PulseEffect(
                      from: Colors.grey.shade300,
                      to: Colors.grey.shade100,
                    ),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text("Dummy Text Dummy Text"),
                        subtitle: Text("Dummy Text Dummy Text Dummy"),
                        trailing: Icon(Icons.circle),
                      ),
                    ),
                  );
                }, childCount: 4),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          slivers.add(
            SliverFillRemaining(
              child: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          slivers.add(
            SliverFillRemaining(
              child: Center(child: Text('No quizzes found.')),
            ),
          );
        } else {
          final quizData = snapshot.data!;
          slivers.add(
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final quizAssignmentId = quizData[index]['quiz']['id'];
                  final quizTitle = quizData[index]['quiz']['title'];
                  final quizDesc = quizData[index]['quiz']['description'];
                  final qaCount = quizData[index]['quiz']['questions_count'];
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
                                  title: quizTitle,
                                  description: quizDesc,
                                  questionsCount: qaCount,
                                  id: quizAssignmentId,
                                ),
                              ),
                        );
                      },
                      title: Text(
                        quizTitle,
                        style: GoogleFonts.robotoFlex(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                        ),
                      ),
                      subtitle: Text(
                        quizDesc,
                        style: GoogleFonts.robotoFlex(
                          color: Colors.black38,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.indigoAccent.withValues(alpha: 0.2),
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
                      ),
                    ),
                  );
                }, childCount: quizData.length),
              ),
            ),
          );
        }
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              MyAppbar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.5,
                  children: [
                    Text(
                      'Hello, ${widget.name}',
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 22.5,
                      ),
                    ),
                    Text(
                      "Let's start your quiz now!",
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                leading: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'assets/images/racool.jpg',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                actions: [
                  MyActionIconButton(
                    icon: FaIcon(FontAwesomeIcons.solidBell),
                    onPressed: () {},
                  ),
                ],
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 20.0,
            ),
            child: QuizMenuTab(snapshot: snapshot,),
          ),
        );
      },
    );
    return futureBuilder;
  }
}
