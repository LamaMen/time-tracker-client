part of 'bloc.dart';

final format = DateFormat('yyyy-MM-dd');

class FiltersState {
  final bool isFull;
  final DateTimeRange? range;

  const FiltersState(this.isFull, this.range);

  ProgressFilters get filters => ProgressFilters(isFull, range);

  String get formattedRange {
    if (range == null) return 'Не выбрано';

    final start = format.format(range!.start);
    final end = format.format(range!.end);

    return '$start - $end';
  }
}
