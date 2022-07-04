import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';

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
          child: _ProjectView(project: projects[index]),
        );
      },
    );
  }
}

class _ProjectView extends StatelessWidget {
  final ProjectWithDuration project;

  const _ProjectView({required this.project});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name),
      subtitle: Text(project.formattedDuration),
      trailing: project is StartedProject
          ? _ProjectActionButton(project: project, isActive: true)
          : _ProjectActionButton(project: project, isActive: false),
    );
  }
}

class _ProjectActionButton extends StatelessWidget {
  final Project project;
  final bool isActive;

  const _ProjectActionButton({required this.project, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final icon = isActive ? Icons.pause_circle_filled : Icons.play_circle_fill;
    final color = isActive ? Colors.grey : Colors.green;
    final event =
        isActive ? StopSessionEvent(project) : StartSessionEvent(project);

    return SizedBox(
      width: 32,
      height: 32,
      child: GestureDetector(
        onTap: () => context.read<ProjectsBloc>().add(event),
        child: Center(child: Icon(icon, color: color, size: 32)),
      ),
    );
  }
}
