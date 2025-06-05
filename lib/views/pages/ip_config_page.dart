import 'package:flutter/material.dart';
import 'package:quizzie/views/pages/access_choice.dart';
import 'package:quizzie/views/styles/common_input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpConfigPage extends StatefulWidget {
  const IpConfigPage({super.key});

  @override
  State<IpConfigPage> createState() => _IpConfigPageState();
}

class _IpConfigPageState extends State<IpConfigPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _ipController;

  Future<void> saveIP(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ip", ip);
  }

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                clipBehavior: Clip.antiAlias,
                controller: _ipController,
                keyboardType: TextInputType.emailAddress,
                decoration: commonTextFieldDecoration("IP"),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  await saveIP(_ipController.text);
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AccessChoice()),
                  );
                },
                child: Text('Save IP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
