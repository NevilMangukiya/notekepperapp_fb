import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  initTime() async {
    await Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/note1.png",
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 15),
            const Text(
              "Note keeper App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
