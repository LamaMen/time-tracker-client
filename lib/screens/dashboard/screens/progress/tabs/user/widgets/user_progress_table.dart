import 'package:flutter/material.dart';
import 'package:time_tracker_client/domain/models/progress/user_progress.dart';

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
  late final ScrollController controllerHorizontal;
  late final ScrollController controllerVertical;

  @override
  void initState() {
    controllerHorizontal = ScrollController();
    controllerVertical = ScrollController();
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
          rows: _rows,
          columns: widget.progress.columns
              .map((c) => DataColumn(label: Text(c)))
              .toList(),
        ),
      ),
    );
  }

  List<DataRow> get _rows {
    return widget.progress.map((line) {
      final cells = line.map((v) => Text(v)).toList();
      return _Row(color: line.background, cells: cells);
    }).toList();
  }

  @override
  void dispose() {
    controllerHorizontal.dispose();
    controllerVertical.dispose();
    super.dispose();
  }
}

class _Row extends DataRow {
  _Row({
    required Color color,
    required List<Widget> cells,
  }) : super(
            color: MaterialStateProperty.all(color),
            cells: cells.map((w) => DataCell(w)).toList());
}
