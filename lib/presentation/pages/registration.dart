import 'package:chatting_app/application/themes/style.dart';
import 'package:chatting_app/presentation/pages/chart.dart';
import 'package:chatting_app/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);
  static String id = 'registration';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool spinner = false;

  void registerUser() async {
    try {
      final UserCredential? newUser =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      if (newUser != null) {
        Navigator.pushNamed(context, ChatApp.id);
        setState(() {
          spinner = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,

                /// Called when the user initiates a change to the
                /// TextField's value: when they have inserted or deleted text.
                onChanged: (value) {
                  email = value;
                },

                /// copywith allows you to make changes to a part e.g our constatnt.
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomButton(
                buttonLabel: 'Register',
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  registerUser();
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
