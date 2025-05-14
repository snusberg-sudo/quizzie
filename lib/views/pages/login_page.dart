import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/api/api_service.dart';
import 'package:quizzie/api/user_data_storage_service.dart';
import 'package:quizzie/views/pages/layout.dart';
import 'package:quizzie/views/styles/common_input_decoration.dart';
import 'package:quizzie/views/styles/common_text_styles.dart';
import 'package:quizzie/views/widgets/outlined_logo_button.dart';
import 'package:quizzie/views/widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> submitLogin() async {
    Map<String, dynamic> requestData = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
    final apiService = ApiService();
    try {
      final response = await apiService.post('/login', requestData);
      await UserDataStorageService.set('token', response.data['token']);
      await UserDataStorageService.set(
        'user_id',
        response.data['user']['id'].toString(),
      );
      await UserDataStorageService.set('email', response.data['user']['email']);
      await UserDataStorageService.set('name', response.data['user']['name']);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 65.0,
        toolbarHeight: 45.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton.outlined(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Icon(Icons.chevron_left_sharp, size: 28.5),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 0.75),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
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
                          style: GoogleFonts.openSans(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
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
                                style: commonTextStyle1,
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
                            side: BorderSide.none,
                            backgroundColor: Colors.indigoAccent,
                            minimumSize: Size(double.infinity, 55.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text("ログイン", style: TextStyle(fontSize: 16.0)),
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
                              child: Text("他の方法でログイン", style: commonTextStyle1),
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
                        style: commonTextStyle1,
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        children: [
                          TextSpan(
                            text: "新規登録はこちら",
                            style: TextStyle(color: Colors.indigoAccent),
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
