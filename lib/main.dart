import 'package:chatting_app/presentation/pages/chart.dart';
import 'package:chatting_app/presentation/pages/login.dart';
import 'package:chatting_app/presentation/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Welcome.id,

      ///key value pair
      routes: {
        Welcome.id: (context) => Welcome(),
        Login.id: (context) => Login(),
        Registration.id: (context) => Registration(),
        ChatApp.id: (context) => ChatApp(),
      },
      home: Registration(),
    );
  }
}
