import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/circular_loader.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/general/general_tab.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/tab_type.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/tabs_widget.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/user_tab.dart';

class StatisticScreen extends StatefulWidget implements AutoRouteWrapper {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatisticBloc>(),
      child: this,
    );
  }
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  void initState() {
    context.read<StatisticBloc>().add(const UpdateTabs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        if (state is WithListState) {
          return TabsWidget(
            tabs: state.statistics.map((s) {
              return TabInfo(
                label: s.label,
                child: s is UserStatisticTab
                    ? UserTab(user: s.user)
                    : const GeneralTab(),
              );
            }).toList(),
          );
        }

        if (state is FailedState) {
          return Center(child: Text(state.failure.message));
        }

        return const Center(child: CircularLoader(size: 40));
      },
    );
  }
}
