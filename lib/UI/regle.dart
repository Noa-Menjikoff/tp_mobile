import 'package:flutter/material.dart';

class ReglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Règles'),
      ),
      body: Center(
        child: Text(
          "Le premier joueur retourne deux cartes. Si les images sont identiques, il gagne la paire constituée et rejoue. Si les images sont différentes, il les repose faces cachées là où elles étaient et c'est au joueur suivant de jouer. La partie est terminée lorsque toutes les cartes ont été assemblées par paires.",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
