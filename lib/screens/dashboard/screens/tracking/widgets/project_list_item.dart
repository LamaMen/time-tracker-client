import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/domain/models/project/project_with_duration.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/edit_project_dialog.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/user_utils.dart';

class ProjectListItem extends StatelessWidget {
  final ProjectWithDuration progress;

  const ProjectListItem({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(progress.project.name),
      subtitle: Text(
        progress.project.isArchive ? 'Архивный' : progress.formattedDuration,
      ),
      trailing: _ProjectActions(progress: progress),
    );
  }
}

class _ProjectActions extends StatelessWidget {
  final ProjectWithDuration progress;

  const _ProjectActions({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ProjectStartButton(
            project: progress.project,
            isActive: progress.inWork,
          ),
          _ProjectActionButton(project: progress.project).onlyAdmin(context),
        ],
      ),
    );
  }
}

enum _PopupAction { edit, archive, delete }

class _ProjectActionButton extends StatelessWidget {
  final Project project;

  const _ProjectActionButton({required this.project});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PopupAction>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<_PopupAction>(
            value: _PopupAction.edit,
            child: Text("Редактировать"),
          ),
          if (!project.isArchive) ...[
            const PopupMenuItem<_PopupAction>(
              value: _PopupAction.archive,
              child: Text("Архивировать"),
            )
          ],
          const PopupMenuItem<_PopupAction>(
            value: _PopupAction.delete,
            child: Text("Удалить", style: TextStyle(color: Colors.red)),
          ),
        ];
      },
      onSelected: (action) {
        if (action == _PopupAction.archive || action == _PopupAction.delete) {
          context
              .read<ProjectsBloc>()
              .add(DeleteProjectEvent(project, action == _PopupAction.archive));
        }

        if (action == _PopupAction.edit) {
          showDialog<Project>(
            context: context,
            builder: (context) {
              return BlocProvider<EditProjectBloc>(
                create: (_) => getIt<EditProjectBloc>(param1: project),
                child: const EditProjectDialog(),
              );
            },
          ).then((project) {
            if (project != null) {
              context.read<ProjectsBloc>().add(UpdateProjectEvent(project));
            }
          });
        }
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

    if (project.isArchive) {
      return const SizedBox.shrink();
    }

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
