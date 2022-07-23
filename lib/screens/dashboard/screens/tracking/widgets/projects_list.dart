import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/admin_widget.dart';

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
          child: _ProjectView(
            project: projects[index].project,
            progress: projects[index].formattedDuration,
          ),
        );
      },
    );
  }
}

class _ProjectView extends StatelessWidget {
  final Project project;
  final String progress;

  const _ProjectView({required this.project, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name),
      subtitle: Text(progress),
      trailing: _ProjectActions(project: project),
    );
  }
}

class _ProjectActions extends StatelessWidget {
  final Project project;

  const _ProjectActions({required this.project});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ProjectStartButton(
            project: project,
            isActive: project is InWorkProject,
          ),
          _ProjectActionButton(project: project).onlyAdmin(context),
        ],
      ),
    );
  }
}

// TODO: для архивированного проекта должна быть доступна только кнопка удаления
class _ProjectActionButton extends StatelessWidget {
  final Project project;

  const _ProjectActionButton({required this.project});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<bool>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<bool>(
            value: true,
            child: Text("Архивировать"),
          ),
          const PopupMenuItem<bool>(
            value: false,
            child: Text("Удалить", style: TextStyle(color: Colors.red)),
          ),
        ];
      },
      onSelected: (isArchive) {
        context
            .read<ProjectsBloc>()
            .add(DeleteProjectEvent(project, isArchive));
      },
    );
  }
}

class _ProjectStartButton extends StatelessWidget {
  final Project project;
  final bool isActive;

  const _ProjectStartButton({required this.project, required this.isActive});

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
