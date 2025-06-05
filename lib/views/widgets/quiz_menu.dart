import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/data/providers/user_data_state.dart';
//import 'package:quizzie/data/providers/quiz_data_state.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';
import 'package:quizzie/views/pages/profile_page.dart';
import 'package:quizzie/views/widgets/quiz_menu_tab.dart';
import 'package:quizzie/views/widgets/quiz_search_bar.dart';

class QuizMenu extends ConsumerWidget {
  const QuizMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataState = ref.watch(userDataProvider);
    final name = userDataState.user?.name;
    final email = userDataState.user?.email;
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          MyAppbar(
            expandedHeight: 170,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(35.0),
              ),
              side: BorderSide(color: Colors.black87, width: 1.5),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "profile-username",
                  child: Material(
                    type: MaterialType.transparency,
                    color: Colors.transparent,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$name',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 18.5,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: "profile-email",
                  child: DefaultTextStyle(
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("$email"),
                    ),
                  ),
                ),
              ],
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 700),
                    reverseTransitionDuration: Duration(milliseconds: 650),
                    pageBuilder:
                        (context, animation, secondaryAnimation) => ProfilePage(
                          name: name,
                          email: email,
                          animation: animation,
                        ),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      const begin = Offset(0.0, -1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      final tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: 'profile-image',
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: child,
                      );
                    },
                    child: toHeroContext.widget,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/avatars/1262.png'),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              MyActionIconButton(
                icon: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
