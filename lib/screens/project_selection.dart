import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/border_card.dart';
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
                  return const LoadingWidget(
                      message: "Benutzer wird geladen...");
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
                      return const LoadingWidget(
                          message: "Projekte werden geladen...");
                    }
                    List<Project> projects = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        await user.loadProjects();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Wähle hier dein Projekt aus."),
                            const SizedBox(height: 30),
                            Expanded(
                              child: ListView.separated(
                                itemCount: projects.length,
                                itemBuilder: (context, index) {
                                  return BorderCard(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        alignment: Alignment.centerLeft,
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.all(20)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        ProjectManager.getInstance()
                                            .currentProject = projects[index];
                                        projects[index].loadSprints();
                                      },
                                      child: Text(
                                        projects[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                              ),
                            ),
                          ],
                        ),
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
