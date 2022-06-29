import 'package:sff/data/model/streamable.dart';

class Ticket extends StreamableObject<Ticket> {
  Ticket(
    super.id,
    this._name,
    this._status,
    this._description,
    this._storyPoints,
    this._rewardClaimed,
    this._assignee,
  );
  String _name;
  String _status;
  String _description;
  int _storyPoints;
  bool _rewardClaimed;
  String? _assignee;
  String get name {
    return _name;
  }

  String get description {
    return _description;
  }

  int get storyPoints {
    return _storyPoints;
  }

  bool get done {
    return _status == "done";
  }

  bool get rewardClaimed {
    return _rewardClaimed;
  }

  String? get assignee {
    return _assignee;
  }

  int get rewardCurrency {
    return storyPoints * 7;
  }

  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(
      json["_id"],
      json["name"],
      json["status"],
      json["description"],
      json["storyPoints"],
      json["rewardClaimed"] ?? false,
      json["assignee"],
    );
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    bool change = json["name"] != name ||
        json["status"] != _status ||
        json["description"] != description ||
        json["storyPoints"] != storyPoints ||
        (json["rewardClaimed"] ?? false) != rewardClaimed ||
        json["assignee"] != assignee;
    _name = json["name"];
    _status = json["status"];
    _description = json["description"];
    _storyPoints = json["storyPoints"];
    _rewardClaimed = json["rewardClaimed"] ?? false;
    _assignee = json["assignee"];
    return change;
  }

  /// only for use in user.dart!
  void setClaimed(bool claimed) {
    if (claimed != rewardClaimed) {
      _rewardClaimed = claimed;
      updateStream();
    }
  }
}
