import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/views/pages/ip_config_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final pageController = PageController(keepPage: true);
  num currentPage = 0;

  Future<void> getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  @override
  Widget build(BuildContext context) {
    final dummyTexts = [
      "このクイズィーでは、様々なジャンルの楽しい質問を通して、あなたの知識とひらめきを試すことができます。",
      "全問正解を目指して、ハイスコアを記録してください。あなたの努力が、このクイズィーでの素晴らしい実績となるでしょう。",
      "さあ、次のレベルへ進んで、さらに考えさせるような新たなクイズに挑戦しましょう。きっと、達成感があなたを待っています。",
    ];
    final dummyTitles = ["クイズィーへようこそ", "最高のスコアを目指して", "次のチャレンジ！"];
    final pages = List.generate(
      3,
      (index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          spacing: 30.0,
          children: [
            FittedBox(
              child: Text(
                dummyTitles.elementAt(index),
                style: GoogleFonts.nunito(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
            Text(
              dummyTexts.elementAt(index),
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blueGrey.shade200,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.0),
              Lottie.asset('assets/lottie/welcome_animation.json'),
              SizedBox(height: 25.0),
              SizedBox(
                height: 210.0,
                child: PageView.builder(
                  itemCount: 3,
                  controller: pageController,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 25.0),
              SmoothPageIndicator(
                controller: pageController,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Color(0xFFCFD8DC),
                  activeDotColor: Colors.indigoAccent,
                  type: WormType.thinUnderground,
                ),
              ),
              SizedBox(height: 40.0),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: Size(280.0, 50.0),
                  backgroundColor: Colors.amberAccent.shade400,
                  side: BorderSide(color: Colors.black87, width: 1.5),
                ),
                onPressed: () async {
                  if (currentPage < 2) {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await getStarted();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                IpConfigPage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(1.0, 0.0);
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
                        transitionDuration: Duration(milliseconds: 600),
                      ),
                    );
                  }
                },
                child: Text(
                  currentPage < 2 ? "次ヘ" : "さあ、始めよう！",
                  style: GoogleFonts.rubik(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
