import 'package:flutter/material.dart';
import 'package:time_tracker_client/domain/usecase/progress/general_statistic.dart';

class GeneralStatisticTable extends StatelessWidget {
  final GeneralStatistic statistic;

  const GeneralStatisticTable(
    this.statistic, {
    super.key,
  });

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
        progress.project,
        progress.duration,
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
