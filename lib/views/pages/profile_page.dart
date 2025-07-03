import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/providers/user_data_state.dart';
import 'package:quizzie/views/pages/access_choice.dart';
import 'package:quizzie/views/pages/avatar_selection.dart';
import 'package:quizzie/views/pages/login_page.dart';
import 'package:quizzie/views/widgets/list_view_navigation.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'package:quizzie/views/widgets/my_appbar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.animation,
  });

  final String? name;
  final String? email;
  final Animation<double> animation;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideUpAnimation;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideUpAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    widget.animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataState = ref.read(userDataProvider.notifier);
    final userData = ref.watch(userDataProvider);
    final avatar = userData.user?.avatar;
    return Scaffold(
      backgroundColor: Colors.amberAccent.shade400,
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MyAppbar(
              expandedHeight: 220.0,
              centerTitle: true,
              backgroundColor: Colors.amberAccent.shade400,
              automaticallyImplyLeading: false,
              actions: [
                MyActionIconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: Colors.black87,
                    size: 20,
                  ),
                  borderRadiusGeometry: BorderRadiusGeometry.circular(30.0),
                  borderSide: BorderSide(color: Colors.black87, width: 1.5),
                  onPressed: () async {
                    if (_isExiting) return;
                    _isExiting = true;
                    await _controller.reverse();
                    if (context.mounted) {
                      Navigator.maybePop(context);
                    }
                  },
                  minS: Size(55, 55),
                ),
              ],
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "profile-image",
                    child: OpenContainer(
                      closedShape: CircleBorder(),
                      transitionDuration: Duration(milliseconds: 650),
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder: (context, action) {
                        return GestureDetector(
                          onTap: action,
                          child: Container(
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 45.0,
                              backgroundImage: AssetImage(
                                'assets/avatars/$avatar',
                              ),
                            ),
                          ),
                        );
                      },
                      openBuilder: (context, action) {
                        return AvatarSelection(currentAvatar: avatar);
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Hero(
                    tag: "profile-username",
                    child: Material(
                      type: MaterialType.transparency,
                      color: Colors.transparent,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.name ?? 'Dummy Name',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.5,
                            letterSpacing: -0.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Hero(
                    tag: "profile-email",
                    child: DefaultTextStyle(
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: -0.5,
                        color: Colors.black87,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(widget.email ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Center(
          child: SlideTransition(
            position: _slideUpAnimation,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(height: 22.0),
                        ListViewNavigation(
                          widgetsList: [
                            {
                              'icon': FontAwesomeIcons.gear,
                              'text': "Settings",
                              'trailingAction': () {},
                              'textColor': Colors.grey.shade100,
                            },
                            {
                              'icon': FontAwesomeIcons.chartSimple,
                              'text': "Statistics",
                              'trailingAction': () {},
                              'textColor': Colors.grey.shade100,
                            },
                            {
                              'icon': FontAwesomeIcons.trophy,
                              'text': "Achievements",
                              'trailingAction': () {},
                              'textColor': Colors.grey.shade100,
                            },
                          ],
                        ),
                        Divider(
                          indent: 25.0,
                          endIndent: 25.0,
                          thickness: 0.75,
                          color: Colors.grey.shade100,
                        ),
                        ListViewNavigation(
                          widgetsList: [
                            {
                              'icon': FontAwesomeIcons.rightFromBracket,
                              'text': "ログアウト",
                              'action': () async {
                                await userDataState.clearUserData();
                                if (!context.mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => AccessChoice(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              'textColor': Colors.grey.shade100,
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
