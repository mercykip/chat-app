import 'package:chatting_app/presentation/pages/login.dart';
import 'package:chatting_app/presentation/pages/registration.dart';
import 'package:chatting_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Welcome extends StatefulWidget {
  static String id = 'welcome';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    /// vsync acts as a ticker
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    animation =
        ColorTween(begin: Colors.red, end: Colors.amber).animate(controller);

    ///controller.reverse(from: 1.0);
    /// see what the controller is doing
    controller.addListener(() {
      setState(() {
        print(animation.value);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('assets/images/logo.png'),
                  height: 60.0,
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "LET'S CHAT",
                    textStyle: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ]),
            SizedBox(
              height: 48.0,
            ),
            CustomButton(
              buttonLabel: 'Log In',
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
            ),
            CustomButton(
                buttonLabel: 'Register',
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, Registration.id);
                }),
          ],
        ),
      ),
    );
  }
}
