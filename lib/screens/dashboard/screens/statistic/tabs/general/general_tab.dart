import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/responsive_utils.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/general/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/general/widgets/general_statistic_list.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/general/widgets/general_statistic_table.dart';

class GeneralTab extends StatelessWidget {
  const GeneralTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneralStatBloc>(
      create: (_) => getIt<GeneralStatBloc>(),
      child: const _GeneralTabBody(),
    );
  }
}

class _GeneralTabBody extends StatefulWidget {
  const _GeneralTabBody();

  @override
  State<_GeneralTabBody> createState() => _GeneralTabBodyState();
}

class _GeneralTabBodyState extends State<_GeneralTabBody> {
  @override
  void initState() {
    context.read<GeneralStatBloc>().add(const GetStatistic());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralStatBloc, GeneralStatState>(
      builder: (context, state) {
        final failure = state is FailedState ? state.failure : null;
        final isLoading = state is LoadingState;
        final Widget child;

        if (state is WithStatisticState) {
          child = ResponsiveWidget(
            mobile: GeneralStatisticList(state.statistics),
            desktop: GeneralStatisticTable(state.statistics),
          );
        } else {
          child = const SizedBox.shrink();
        }

        return WidgetWithTopLoader(
          isLoading: isLoading,
          failure: failure,
          child: child,
        );
      },
    );
  }
}
