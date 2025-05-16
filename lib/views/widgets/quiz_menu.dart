import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/widgets/quiz_menu_appbar.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key, required this.name});

  final String? name;

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  Future<List<Map<dynamic, dynamic>>> getQuizzies() async {
    final apiService = ApiService();
    try {
      final response = await apiService.get('/user/quiz-assignments');
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
        slivers.add(QuizMenuAppbar(title: widget.name));
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Text(
                "Recent Quiz",
                style: GoogleFonts.robotoFlex(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          slivers.add(
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
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
                  final quizTitle = quizData[index]['quiz']['title'];
                  final quizDesc = quizData[index]['quiz']['description'];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
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
                    ),
                  );
                }, childCount: quizData.length),
              ),
            ),
          );
        }
        return CustomScrollView(slivers: slivers);
      },
    );
    return futureBuilder;
  }
}
