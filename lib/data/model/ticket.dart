import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/model/streamable.dart';

class Ticket extends Streamable<Ticket> {
  Ticket(
    super.id,
    this._name,
    this._description,
    this._storyPoints,
    this._duration,
    this._done,
    this._rewardClaimed,
    this._assignee,
  );
  String _name;
  String _description;
  int _storyPoints;
  double _duration;
  bool _done;
  bool _rewardClaimed;
  String _assignee;
  String get name {
    return _name;
  }

  String get description {
    return _description;
  }

  int get storyPoints {
    return _storyPoints;
  }

  double get duration {
    return _duration;
  }

  bool get done {
    return _done;
  }

  bool get rewardClaimed {
    return _rewardClaimed;
  }

  String get assignee {
    return _assignee;
  }

  int get rewardCurrency {
    return storyPoints * 7;
  }

  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(
      json["_id"],
      json["name"],
      json["description"],
      json["storyPoints"],
      json["duration"].toDouble(),
      json["done"],
      json["rewardClaimed"],
      json["assignee"],
    );
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    bool change = json["name"] != name ||
        json["description"] != description ||
        json["storyPoints"] != storyPoints ||
        json["duration"].toDouble() != duration ||
        json["done"] != done ||
        json["rewardClaimed"] != rewardClaimed ||
        json["assignee"] != assignee;
    _name = json["name"];
    _description = json["description"];
    _storyPoints = json["storyPoints"];
    _duration = json["duration"].toDouble();
    _done = json["done"];
    _rewardClaimed = json["rewardClaimed"];
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
