import 'dart:async';
import 'package:flutter/material.dart';
import 'BD.dart';
import 'DatabaseHelper.dart';
import 'item.dart';

class MemoryGame extends StatefulWidget {
  final String playerName;

  MemoryGame({required this.playerName});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  // Définir les niveaux du jeu avec le nombre d'images dans chaque niveau
  List<List<Item>> levels = [
    [
      Item("images/kaneki.png"),
      Item("images/toka.png"),
    ],
    [
      Item("images/shanks.png"),
      Item("images/nami.png"),
      Item("images/luffy.png"),
    ],

  ];

  List<Item> shuffledItems = [];
  List<int> selectedIndex = [];
  bool canFlip = true;
  int previousIndex = -1;
  int moves = 0;
  int matchedPairs = 0;
  int currentLevel = 0;

  Timer? timer;
  int secondsRemaining = 60; // Initialiser le timer à 1 minute

  @override
  void initState() {
    super.initState();
    startTimer();
    resetGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel(); // Arrêter le timer une fois que le temps est écoulé
          showGameOverDialog();
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      shuffledItems = []..addAll(levels[currentLevel])..addAll(levels[currentLevel]);
      shuffledItems.shuffle();
      selectedIndex = [];
      previousIndex = -1;
      moves = 0;
      matchedPairs = 0;
      secondsRemaining = 60; // Réinitialiser le timer à 1 minute pour chaque niveau
      canFlip = true;
    });
  }

  void onTileClicked(int index) {
    // Vérifiez si le joueur a terminé le dernier niveau
    if (currentLevel == levels.length - 1 && matchedPairs == levels[currentLevel].length) {
      showVictoryScreen();
      return;
    }

    if (!canFlip || selectedIndex.contains(index)) return;

    if (previousIndex == -1) {
      previousIndex = index;
      selectedIndex.add(index);
    } else {
      moves++;
      selectedIndex.add(index);
      if (shuffledItems[previousIndex].image !=
          shuffledItems[index].image) {
        canFlip = false;
        Future.delayed(Duration(milliseconds: 1000), () {
          setState(() {
            selectedIndex.remove(index);
            selectedIndex.remove(previousIndex);
            previousIndex = -1;
            canFlip = true;
          });
        });
      } else {
        previousIndex = -1;
        matchedPairs++;
        if (matchedPairs == levels[currentLevel].length) {
          if (currentLevel < levels.length - 1) {
            currentLevel++;
            resetGame();
          } else {
            timer?.cancel();
            showVictoryScreen();
          }
        }
      }
    }

    setState(() {});
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You ran out of time!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
                startTimer();
              },
              child: Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveScore(widget.playerName);
                Navigator.of(context).pop(); // Fermer le MemoryGame
              },
              child: Text("Back to Home"),
            ),
          ],
        );
      },
    );
  }

  void showVictoryScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You completed all levels!"),
              Text("Moves: $moves"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveScore(widget.playerName);
                Navigator.of(context).pop(); // Fermer le MemoryGame
              },
              child: Text("Back to Home"),
            ),
          ],
        );
      },
    );
  }

  void saveScore(String playerName) async {
    final score = Score(
      playerName: playerName,
      level: currentLevel + 1,
      moves: moves,
      timestamp: DateTime.now(),
    );
    await DatabaseHelper.instance.insertScore(score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${currentLevel + 1}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Moves: $moves",
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  "Time: ${secondsRemaining}s",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: shuffledItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onTileClicked(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex.contains(index)
                          ? Colors.grey
                          : Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: selectedIndex.contains(index)
                          ? Expanded(
                        child: Image.asset(
                          shuffledItems[index].image,
                          fit: BoxFit.cover,
                        ),
                      )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
