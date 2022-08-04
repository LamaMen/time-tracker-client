import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/edit_project_dialog.dart';

class AddProjectButton extends StatelessWidget {
  final bool isActive;

  const AddProjectButton({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          showDialog<Project>(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (_) => getIt<EditProjectBloc>(
                  param1: Project(-1, '', false),
                ),
                child: const EditProjectDialog(),
              );
            },
          ).then((project) {
            if (project != null) {
              context.read<ProjectsBloc>().add(AddProjectEvent(project));
            }
          });
        },
        child: Row(
          children: const [
            Icon(Icons.add, color: Colors.white),
            Text(
              'Создать проект',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
