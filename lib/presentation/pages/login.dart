import 'package:chatting_app/application/themes/style.dart';
import 'package:chatting_app/presentation/pages/chart.dart';
import 'package:chatting_app/presentation/pages/registration.dart';
import 'package:chatting_app/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;

  bool spinner = false;
  // Initially password is obscure
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  /// validate user
  Future<void> validateUser() async {
    try {
      final UserCredential? userCredential =
          await _auth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      if (userCredential != null) {
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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    // height: 200.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Login to Flash Chat',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 40.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: !_passwordVisible,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password.',
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomButton(
                buttonLabel: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: () {
                  setState(() {
                    spinner = true;
                  });
                  validateUser();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Text('Forget Your password ',
                          textAlign: TextAlign.left)),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Registration.id);
                      },
                      child: Text('Sign Up ', textAlign: TextAlign.right)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
