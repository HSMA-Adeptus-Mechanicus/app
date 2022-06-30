import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/sprint.dart';
import 'package:sff/data/model/streamable.dart';

class Project extends StreamableObject<Project> {
  Project(super.id, this._name, this._avatarUrl, this._sprints, this._team);

  String _name;
  String _avatarUrl;
  List<String> _sprints;
  List<String> _team;

  String get name {
    return _name;
  }

  String get avatarUrl {
    return _avatarUrl;
  }

  List<String> get sprints {
    return _sprints;
  }

  List<String> get team {
    return _team;
  }

  static Project fromJSON(Map<String, dynamic> json) {
    return Project(
      json["_id"],
      json["name"],
      json["avatarUrl"],
      (json["sprints"] as List<dynamic>).whereType<String>().toList(),
      (json["team"] as List<dynamic>).whereType<String>().toList(),
    );
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    List<String> newSprints =
        (json["sprints"] as List<dynamic>).whereType<String>().toList();
    List<String> newTeam =
        (json["team"] as List<dynamic>).whereType<String>().toList();
    bool change = name != json["name"] ||
        avatarUrl != json["avatarUrl"] ||
        newSprints.length != sprints.length ||
        newTeam.length != team.length ||
        !newSprints.every((element) => sprints.contains(element)) ||
        !newTeam.every((element) => team.contains(element));
    _name = json["name"];
    _avatarUrl = json["avatarUrl"];
    _sprints = newSprints;
    _team = newTeam;
    return change;
  }

  Future<void> loadSprints() async {
    await authAPI.post("load-jira", {
      "resources": [
        {
          "type": "sprints",
          "args": {
            "projectId": id,
          },
        },
      ],
    });
    await CachedAPI.getInstance().request("db/projects");
    await CachedAPI.getInstance().request("db/sprints");
  }

  Stream<List<Sprint>> getSprintsStream() async* {
    Stream<List<Sprint>> sprintsStream = data.getSprintsStream();
    await for (List<Sprint> sprintObjects in sprintsStream) {
      yield sprintObjects
          .where((element) => sprints.contains(element.id))
          .toList();
    }
  }

  Future<Sprint> getCurrentSprint() async {
    // TODO: prevent infinite loading if the project does not have any sprints
    List<Sprint> sprintObjects = await first(getSprintsStream());
    sprintObjects.retainWhere((element) => sprints.contains(element.id));
    Sprint sprint;
    if (sprintObjects.isEmpty) {
      throw Exception("There are no sprints");
    }
    try {
      sprint = sprintObjects.firstWhere((element) => element.state == "active");
    } catch (e) {
      List<Sprint> sorted =
          sprintObjects.where((e) => e.state == "future").toList();
      if (sorted.isEmpty) {
        throw Exception("There is no active or upcoming sprint");
      }
      sorted.sort((a, b) => a.start.compareTo(b.start));
      sprint = sorted[0];
    }
    sprint.loadTickets();
    return sprint;
  }
}

class ProjectManager extends Streamable<ProjectManager> {
  static final ProjectManager _projectManager = ProjectManager();

  static ProjectManager getInstance() {
    return _projectManager;
  }

  static Stream<ProjectManager> getStream() {
    return _projectManager.asStream();
  }

  Project? _currentProject;
  Project? get currentProject {
    return _currentProject;
  }

  set currentProject(Project? project) {
    _currentProject = project;
    updateStream();
  }
}
