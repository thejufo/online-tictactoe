import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tictactoe/game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 88,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Multi-Player',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tic Tac Toe',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Start'),
        onPressed: () {
          Get.to(const GameScreen());
        },
      ),
    );
  }
}
