import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/buttons/simple_button.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/edit_project_dialog.dart';

class AddProjectButton extends StatefulWidget {
  final bool isActive;

  const AddProjectButton({super.key, required this.isActive});

  @override
  State<AddProjectButton> createState() => _AddProjectButtonState();
}

class _AddProjectButtonState extends State<AddProjectButton> {
  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      width: 165,
      height: 36,
      onPressed: widget.isActive ? onPressed : null,
      child: Row(
        children: const [
          Icon(Icons.add, color: Colors.white),
          Text(
            'Создать проект',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> onPressed() async {
    final project = await showDialog<Project>(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => getIt<EditProjectBloc>(
            param1: Project(-1, '', false),
          ),
          child: const EditProjectDialog(),
        );
      },
    );

    if (mounted && project != null) {
      context.read<ProjectsBloc>().add(AddProjectEvent(project));
    }
  }
}
