import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBP1Le7W6jCraQe5q9-AndpoxQHmCDuy00",
      authDomain: "tictactoe-f9693.firebaseapp.com",
      projectId: "tictactoe-f9693",
      storageBucket: "tictactoe-f9693.appspot.com",
      messagingSenderId: "654389694674",
      appId: "1:654389694674:web:896973dfeba704fa4add0b",
      measurementId: "G-RLXL9HT4BC",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
