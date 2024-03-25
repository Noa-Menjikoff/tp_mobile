import 'package:flutter/material.dart';
import 'BD.dart';
import 'DatabaseHelper.dart';

class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score'),
      ),
      body: FutureBuilder<List<Score>>(
        future: DatabaseHelper.instance.getScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No scores yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final score = snapshot.data![index];
                return ListTile(
                  title: Text(score.playerName),
                  subtitle: Text('Level: ${score.level}, Moves: ${score.moves}'),
                  trailing: Text(score.timestamp.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
