import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/filters/bloc/bloc.dart';

class FiltersDialog extends StatefulWidget {
  const FiltersDialog({super.key});

  @override
  State<FiltersDialog> createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Фильтр'),
          content: SizedBox(
            width: 250,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: state.isFull,
                      onChanged: (bool? value) {
                        context
                            .read<FiltersBloc>()
                            .add(ChangeIsFullEvent(value));
                      },
                    ),
                    const Text('Показывать все проекты'),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(state.formattedRange),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      initialDateRange: state.range,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (!mounted) return;
                    context.read<FiltersBloc>().add(ChangeRangeEvent(range));
                  },
                  child: const Text('Изменить промежуток'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Закрыть'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(state.filters),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
