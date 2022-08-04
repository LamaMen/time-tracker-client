import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';

class ProjectsFilter extends StatelessWidget {
  const ProjectsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (contest, state) {
              return Checkbox(
                value: state.isFull,
                onChanged: (bool? value) {
                  context
                      .read<ProjectsBloc>()
                      .add(ChangeFlagEvent(value ?? false));
                },
              );
            },
          ),
          const Text('Показывать все проекты'),
        ],
      ),
    );
  }
}
