import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  final choices = [
    '', '', '',
    '', '', '',
    '', '', '',
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

  final turn = 'X'.obs;

  void choiceClick(int index, String currentPlayer) {
    if (choices[index].isEmpty) {
      choices[index] = turn.value;
      if (combinations.any((combination) {
        return choices.every((String choice) {
          return combination.every((int index) {
            return choices[index] == turn.value;
          });
        });
      })) {
        showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: const Text('Nice Work'),
            content: Text('Player $currentPlayer has won!'),
          );
        });
      }
      turn.value = turn.value == 'X' ? 'O' : 'X';
    }
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
                    mainAxisExtent: width / 3
                ),
                itemCount: choices.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () => choiceClick(index, turn.value),
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
