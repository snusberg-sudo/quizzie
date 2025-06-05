import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/data/providers/user_data_state.dart';
import 'package:quizzie/views/pages/access_choice.dart';
import 'package:quizzie/views/pages/layout.dart';
import 'package:quizzie/views/styles/common_input_decoration.dart';
import 'package:quizzie/views/widgets/outlined_logo_button.dart';
import 'package:quizzie/views/widgets/password_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> submitLogin() async {
    Map<String, dynamic> requestData = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
    final apiService = ref.read(apiServiceProvider);
    try {
      final response = await apiService.post('/login', requestData);
      final userState = ref.read(userDataProvider.notifier);
      await userState.saveUserData(
        response.data['user']['id'].toString(),
        response.data['token'],
        response.data['user']['email'],
        response.data['user']['name']
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Layout()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        leadingWidth: 65.0,
        toolbarHeight: 45.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton.outlined(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccessChoice()),
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 19.5,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.white, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          "おかえりなさい！またお会いできて嬉しいです！",
                          style: GoogleFonts.rubik(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 35.0),
                        TextField(
                          clipBehavior: Clip.antiAlias,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: commonTextFieldDecoration("メールアドレス"),
                        ),
                        SizedBox(height: 20.0),
                        PasswordField(passwordController: passwordController),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              clipBehavior: Clip.antiAlias,
                              onPressed: () {},
                              style: TextButton.styleFrom(),
                              child: Text(
                                "パスワードをお忘れですか？",
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        FilledButton(
                          onPressed: () {
                            submitLogin();
                          },
                          clipBehavior: Clip.antiAlias,
                          style: FilledButton.styleFrom(
                            side: BorderSide(
                              color: Colors.black87,
                              width: 1.25,
                            ),
                            backgroundColor: Colors.amberAccent.shade400,
                            minimumSize: Size(double.infinity, 55.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            "ログイン",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade200,
                                thickness: 1,
                                indent: 0,
                                endIndent: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              child: Text(
                                "他の方法でログイン",
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade200,
                                thickness: 1,
                                indent: 15,
                                endIndent: 0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          spacing: 10.0,
                          children: [
                            Expanded(
                              child: OutlinedLogoButton(
                                logoPath: "assets/images/facebook.png",
                                logoWidth: 35.0,
                                logoHeight: 35.0,
                              ),
                            ),
                            Expanded(
                              child: OutlinedLogoButton(
                                logoPath: "assets/images/google.png",
                                logoWidth: 45.0,
                                logoHeight: 45.0,
                              ),
                            ),
                            Expanded(
                              child: OutlinedLogoButton(
                                logoPath: "assets/images/apple.png",
                                logoWidth: 35.0,
                                logoHeight: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 35.0, top: 15.0),
                    child: RichText(
                      text: TextSpan(
                        text: "初めてですか？ ",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        children: [
                          TextSpan(
                            text: "新規登録はこちら",
                            style: TextStyle(
                              color: Colors.amberAccent.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
