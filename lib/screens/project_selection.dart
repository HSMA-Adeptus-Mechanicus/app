import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/loading.dart';

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
            body: LoadingWidget(),
          );
        }
        ProjectManager projectManager = snapshot.data!;
        if (projectManager.currentProject == null) {
          return AppScaffold(
            body: StreamBuilder<User>(
              stream: data.getCurrentUserStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingWidget(message: "Benutzer wird geladen...");
                }
                User user = snapshot.data!;
                user.loadProjects();
                return StreamBuilder<List<Project>>(
                  stream: user.getProjectsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorWidget(snapshot.error!);
                    }
                    if (!snapshot.hasData) {
                      return const LoadingWidget(message: "Projekte werden geladen...");
                    }
                    List<Project> projects = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        await user.loadProjects();
                      },
                      child: ListView.separated(
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
                      ),
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
