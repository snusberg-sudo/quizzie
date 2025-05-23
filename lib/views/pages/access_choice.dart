import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzie/views/pages/login_page.dart';

class AccessChoice extends StatelessWidget {
  const AccessChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 130.0),
                Lottie.asset('assets/lottie/choice.json'),
                SizedBox(height: 90.0),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                LoginPage(),
                        transitionDuration: Duration(milliseconds: 600),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
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
                  clipBehavior: Clip.antiAlias,
                  style: FilledButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: Colors.indigoAccent,
                    minimumSize: Size(double.infinity, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "ログイン",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 30.0),
                OutlinedButton(
                  onPressed: () {},
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.indigoAccent, width: 1.25),
                    minimumSize: Size(double.infinity, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "サインアップ",
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
