import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/widgets/app_scaffold.dart';

class ProjectSelection extends StatelessWidget {
  const ProjectSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProjectManager>(
      stream: ProjectManager.getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AppScaffold(
            settingsButton: false,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        ProjectManager projectManager = snapshot.data!;
        if (projectManager.currentProject == null) {
          return AppScaffold(
            body: StreamBuilder<User>(
              stream: data.getCurrentUserStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<List<Project>>(
                  stream: snapshot.data!.getProjectsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<Project> projects = snapshot.data!;
                    return ListView.separated(
                      padding: const EdgeInsets.all(30),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            ProjectManager.getInstance().currentProject =
                                projects[index];
                            projects[index].loadSprints();
                          },
                          child: Text(projects[index].name),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                    );
                  },
                );
              },
            ),
          );
        }
        return const AppFrame();
      },
    );
  }
}
