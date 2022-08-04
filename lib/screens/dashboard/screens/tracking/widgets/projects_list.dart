import 'package:flutter/material.dart';
import 'package:time_tracker_client/domain/models/project/project_with_duration.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/project_list_item.dart';

class ProjectsList extends StatelessWidget {
  final List<ProjectWithDuration> projects;

  const ProjectsList({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Theme.of(context).primaryColorLight),
          ),
          child: ProjectListItem(progress: projects[index]),
        );
      },
    );
  }
}
