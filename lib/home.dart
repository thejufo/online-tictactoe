import 'package:cloud_firestore/cloud_firestore.dart';
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

  final games = [].obs;
  final controller = TextEditingController();

  void joinGame(String gameId) {
    void join() async {
      final name = controller.text;
      if (name.isNotEmpty) {
        final db = FirebaseFirestore.instance;
        final game = {'player2': controller.text};

        await db.collection('games').doc(gameId).update(game);

        Get.back();
        Get.to(GameScreen(gameId: gameId, currentPlayer: name));
      }
    }

    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('Join a Game'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter Name',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          TextButton(onPressed: join, child: const Text('JOIN')),
        ],
      );
    });
  }

  void startGame() {

    void start() async {
      final name = controller.text;
      if (name.isNotEmpty) {
        final db = FirebaseFirestore.instance;
        final game = {
          'choices': [
            '', '', '',
            '', '', '',
            '', '', '',
          ],
          'turn': 'X',
          'player1': controller.text,
        };

        final doc = await db.collection('games').add(game);

        Get.back();
        Get.to(GameScreen(gameId: doc.id, currentPlayer: name));
      }
    }

    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('Start a New Game'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter Name',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          TextButton(onPressed: start, child: const Text('START')),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final db = FirebaseFirestore.instance;
    db.collection('games').snapshots().listen((event) {
      games.clear();
      for (final doc in event.docs) {
        games.add({'id': doc.id, ...doc.data()});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
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
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              'Tic Tac Toe',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Start'),
        onPressed: () => startGame(),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (ctx, index) {
            final game = games[index];
            return ListTile(
              title: Text(game['player1']),
              trailing: ElevatedButton(
                onPressed: () => joinGame(game['id']),
                child: const Text('JOIN'),
              ),
            );
          },
        );
      }),
    );
  }
}
