import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/add_amendment/add_amendment_button.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/user_progress_table.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/user_utils.dart';

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
        return _UserTabBody(user, filters);
      }),
    );
  }
}

class _UserTabBody extends StatelessWidget {
  final User? user;
  final ProgressFilters filters;

  const _UserTabBody(this.user, this.filters);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          final failure = state is FailedState ? state.failure : null;
          final isLoading = state is LoadingState;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WidgetWithTopLoader(
                  isLoading: isLoading,
                  failure: failure,
                  child: state is WithProgressState
                      ? UserProgressTable(progress: state.progress)
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 8),
              AddAmendmentButton(
                isActive: !isLoading && failure == null,
                user: user,
                range: filters.range ?? currentMonth(),
              ).onlyAdmin(context),
            ],
          );
        },
      ),
    );
  }
}
