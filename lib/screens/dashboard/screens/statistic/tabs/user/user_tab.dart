import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/user_progress_table.dart';

class UserTab extends StatelessWidget {
  final User? user;
  final ProgressFilters filters;

  const UserTab({super.key, required this.user, required this.filters});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressBloc>(
      create: (_) => getIt<ProgressBloc>(),
      child: Builder(builder: (context) {
        context.read<ProgressBloc>().add(GetStatistic(user, filters));
        return const _UserTabBody();
      }),
    );
  }
}

class _UserTabBody extends StatelessWidget {
  const _UserTabBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          final failure = state is FailedState ? state.failure : null;
          final isLoading = state is LoadingState;

          return WidgetWithTopLoader(
            isLoading: isLoading,
            failure: failure,
            child: state is WithProgressState
                ? UserProgressTable(progress: state.progress)
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
