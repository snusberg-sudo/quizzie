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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: QuizMenuTab(snapshot: snapshot, onRefresh: getQuizzies),
          ),
        );
      },
    );
    return futureBuilder;
  }
}
