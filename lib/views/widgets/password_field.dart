import 'package:flutter/material.dart';
import 'package:quizzie/views/styles/common_input_decoration.dart';


class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.passwordController});
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !passwordVisible,
      clipBehavior: Clip.antiAlias,
      controller: widget.passwordController,
      decoration: commonTextFieldDecoration(
        "パスワード",
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            icon: Icon(
              passwordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}
