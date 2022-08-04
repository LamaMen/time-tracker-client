import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/add_project_button.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/projects_filter.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/projects_list.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/user_utils.dart';

class TrackingScreen extends StatefulWidget implements AutoRouteWrapper {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProjectsBloc>(),
      child: this,
    );
  }
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    context.read<ProjectsBloc>().add(LoadProjectsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          final failure = state is FetchFailedState ? state.failure : null;
          final isLoading = state is FetchProjectsState;
          final body = state is ProjectsLoadedState
              ? ProjectsList(projects: state.projects)
              : null;

          return WidgetWithTopLoader(
            isLoading: isLoading,
            failure: failure,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const _Header(),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: body,
                  ),
                ),
                _Footer(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        ProjectsFilter(),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final ProjectsState state;

  const _Footer({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AddProjectButton(isActive: state is ProjectsLoadedState)
            .onlyAdmin(context)
      ],
    );
  }
}
