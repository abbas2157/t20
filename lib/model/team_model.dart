class CricketTeamModel {
  String? team;
  String? flag;
  List<Squad>? squad;

  CricketTeamModel({this.team, this.flag, this.squad});

  CricketTeamModel.fromJson(Map<String, dynamic> json) {
    team = json['team'];
    flag = json['flag'];
    if (json['squad'] != null) {
      squad = <Squad>[];
      json['squad'].forEach((v) {
        squad!.add(new Squad.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['team'] = team;
    data['flag'] = flag;
    if (squad != null) {
      data['squad'] = squad!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Squad {
  String? name;
  String? picture;

  Squad({this.name, this.picture});

  Squad.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['picture'] = picture;
    return data;
  }
}
