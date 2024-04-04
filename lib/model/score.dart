class Score {
  final int? id;
  final String playerName;
  final int level;
  final int moves;
  final DateTime timestamp;

  Score({this.id, required this.playerName, required this.level, required this.moves, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'level': level,
      'moves': moves,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static Score fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      playerName: map['playerName'],
      level: map['level'],
      moves: map['moves'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
