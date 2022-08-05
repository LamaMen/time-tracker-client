import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_client/domain/models/progress/general_statistic.dart';

class UserProgressTable extends StatefulWidget {
  final UserProgress progress;

  const UserProgressTable({
    super.key,
    required this.progress,
  });

  @override
  State<UserProgressTable> createState() => _UserProgressTableState();
}

class _UserProgressTableState extends State<UserProgressTable> {
  late final DateFormat format;
  final controllerHorizontal = ScrollController();
  final controllerVertical = ScrollController();

  @override
  void initState() {
    initializeDateFormatting();
    format = DateFormat('d.MMMyyyy, EEE', 'ru');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controllerVertical,
      child: SingleChildScrollView(
        controller: controllerHorizontal,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 28,
          headingRowColor: MaterialStateProperty.all(
            const Color.fromRGBO(250, 250, 250, 1),
          ),
          border: TableBorder.symmetric(
            outside: const BorderSide(color: Color.fromRGBO(220, 220, 220, 1)),
          ),
          columns: columns,
          rows: _rows,
        ),
      ),
    );
  }

  List<DataColumn> get columns {
    final List<DataColumn> columns = [];
    columns.add(const DataColumn(label: Text('Дата')));
    for (var p in widget.progress.projects) {
      columns.add(DataColumn(label: Text(p.name)));
    }
    columns.add(const DataColumn(label: Text('Проверка')));
    return columns;
  }

  List<DataRow> get _rows {
    final rows = <DataRow>[];

    for (int i = 0; i < widget.progress.dates.length; i += 1) {
      final date = widget.progress.dates[i];
      final columns = [Text(format.format(date))];

      for (int j = 0; j < widget.progress.projects.length; j += 1) {
        columns.add(Text(widget.progress.durations[i][j].toString()));
      }

      columns.add(Text(widget.progress.check[i].toString()));
      final isHoliday =
          date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;

      rows.add(_Row(
        cells: columns,
        type: isHoliday ? _RowType.holiday : _RowType.weekday,
      ));
    }

    final totalColumns = [const Text('Всего')];
    for (int i = 0; i < widget.progress.projects.length; i += 1) {
      totalColumns.add(Text(widget.progress.total[i].toString()));
    }
    totalColumns.add(Text(widget.progress.check.last.toString()));
    rows.add(_Row(cells: totalColumns, type: _RowType.total));

    return rows;
  }

  @override
  void dispose() {
    controllerHorizontal.dispose();
    controllerVertical.dispose();
    super.dispose();
  }
}

enum _RowType {
  weekday(Colors.white),
  holiday(Colors.red),
  total(Color.fromRGBO(250, 250, 250, 1));

  final Color color;

  const _RowType(this.color);
}

class _Row extends DataRow {
  _Row({
    required _RowType type,
    required List<Widget> cells,
  }) : super(
            color: MaterialStateProperty.all(type.color),
            cells: cells.map((w) => DataCell(w)).toList());
}
