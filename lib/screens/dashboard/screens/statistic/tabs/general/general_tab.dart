import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/domain/usecase/statistic/general_statistic.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/general/bloc/bloc.dart';

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
        final child = state is WithStatisticState
            ? _GeneralStatisticTable(statistic: state.statistics)
            : const SizedBox.shrink();

        return WidgetWithTopLoader(
          isLoading: isLoading,
          failure: failure,
          child: child,
        );
      },
    );
  }
}

class _GeneralStatisticTable extends StatelessWidget {
  final GeneralStatistic statistic;

  const _GeneralStatisticTable({required this.statistic});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            headingRowHeight: 28,
            headingRowColor: MaterialStateProperty.all(
              const Color.fromRGBO(250, 250, 250, 1),
            ),
            border: TableBorder.symmetric(
              outside:
                  const BorderSide(color: Color.fromRGBO(220, 220, 220, 1)),
            ),
            columns: const <DataColumn>[
              DataColumn(label: Text('Наименование')),
              DataColumn(label: Text('В ч')),
              DataColumn(label: Text('В %')),
            ],
            rows: _rows,
          ),
        ],
      ),
    );
  }

  List<DataRow> get _rows {
    final rows = <DataRow>[];

    for (var progress in statistic.projectProgress) {
      rows.add(_GeneralStatisticRow(
        progress.project.name,
        progress.duration.toString(),
        progress.formattedPercent,
      ));
    }

    rows.add(_GeneralStatisticRow(
      'Итого:',
      statistic.total.toString(),
      statistic.formattedPercent,
    ));

    return rows;
  }
}

class _GeneralStatisticRow extends DataRow {
  _GeneralStatisticRow(
    String projectName,
    String total,
    String percent,
  ) : super(color: MaterialStateProperty.all(Colors.white), cells: <DataCell>[
          DataCell(Text(projectName)),
          DataCell(Text(total.toString())),
          DataCell(Text(percent)),
        ]);
}
