import 'package:flutter/material.dart';
import 'gamePage.dart';
import 'reglePage.dart';
import 'scorePage.dart';

class HomePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReglePage(),
                ),
              );
            },
            icon: Icon(Icons.help),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScorePage(),
                ),
              );
            },
            icon: Icon(Icons.leaderboard),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showNameDialog(context);
              },
              child: Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, nameController.text);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemoryGame(playerName: value),
          ),
        );
      }
    });
  }
}
