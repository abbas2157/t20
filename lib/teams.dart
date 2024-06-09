class Team {
  final String name;
  final String imageUrl;
  final List<Player> players;

  Team({
    required this.name,
    required this.imageUrl,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    List<dynamic> squadList = json['squad'];
    List<Player> players =
        squadList.map((playerJson) => Player.fromJson(playerJson)).toList();

    return Team(
      name: json['team'],
      imageUrl: json['flag'],
      players: players,
    );
  }
}

class Player {
  final String name;
  final String imageUrl;

  Player({
    required this.name,
    required this.imageUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      imageUrl: json['picture'],
    );
  }
}
