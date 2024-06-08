import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:keep_notes/add_task.dart';
import 'package:keep_notes/home_screen.dart';
import 'package:keep_notes/login_user.dart';
import 'package:keep_notes/signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
       
      home: _auth.currentUser==null? const SignupScreen(): const HomeScreen(),
      routes: {
        '/signupScreen': (context) => const SignupScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/addTask': (context) => const AddTask(),
      },
    );
  }
}
