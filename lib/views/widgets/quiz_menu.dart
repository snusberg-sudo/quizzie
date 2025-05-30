import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:quizzie/views/widgets/quiz_menu_tab.dart';
import 'package:quizzie/views/widgets/quiz_search_bar.dart';

class QuizMenu extends ConsumerWidget {
  const QuizMenu({super.key, required this.name});

  final String? name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDataState = ref.watch(quizDataProvider);
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          MyAppbar(
            expandedHeight: 170,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.5,
              children: [
                Text(
                  'Hello, $name',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22.5,
                    letterSpacing: -0.7,
                  ),
                ),
                Text(
                  "Let's start your quiz now!",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    fontSize: 13.5,
                    letterSpacing: -0.6,
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
                icon: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {},
                borderRadiusGeometry: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.white70, width: 1),
                backgroundColor: Colors.grey.shade100.withValues(alpha: 0.2),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [QuizSearchBar()],
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: QuizMenuTab(),
      ),
    );
  }
}
