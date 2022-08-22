import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'MessagePage.dart';
import 'ChatsPage.dart';
import 'LoginGooglePage.dart';
import 'PhoneCallProject.dart';
import 'SplashScreen.dart';
import 'TabBarPage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
