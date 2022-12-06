import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    Key? key,
    required this.gameId,
    required this.currentPlayer,
  }) : super(key: key);

  final String gameId;
  final String currentPlayer;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final choices = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ].obs;

  final combinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  String turn = 'X';

  final player1 = ''.obs;
  final player2 = ''.obs;

  void choiceClick(int index) async {
    final db = FirebaseFirestore.instance;

    if (choices[index].isEmpty) {
      if (player2.value.isNotEmpty) {
        if ((widget.currentPlayer == player1.value && turn == 'X') ||
            (widget.currentPlayer == player2.value && turn == 'O')) {
          choices[index] = turn;

          turn = turn == 'X' ? 'O' : 'X';

          await db.collection('games').doc(widget.gameId).update({
            'choices': choices,
            'turn': turn,
          });

          checkWinner();
        }
      }
    }
  }

  void checkWinner() {
    if (combinations.any((combination) {
      return choices.every((String choice) {
        return combination.every((int index) {
          return choices[index] == turn;
        });
      });
    })) {
      showWinner();
    }
  }

  void showWinner() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Nice Work'),
            content: Text('Player $turn has won!'),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    final db = FirebaseFirestore.instance;
    db.collection('games').doc(widget.gameId).snapshots().listen((doc) {
      if (doc.data()?['player1'] != null) {
        player1.value = doc.data()?['player1'];
      }

      if (doc.data()?['player2'] != null) {
        player2.value = doc.data()?['player2'];
      }

      for (int i = 0; i < choices.length; i++) {
        choices[i] = doc.data()?['choices'][i];
      }

      checkWinner();

      turn = doc.data()?['turn'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            color: Colors.grey[400],
            child: Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    mainAxisExtent: width / 3),
                itemCount: choices.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () => choiceClick(index),
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          choices[index],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
