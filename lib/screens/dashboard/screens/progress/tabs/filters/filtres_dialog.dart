import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/progress/tabs/filters/bloc/bloc.dart';

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
          content: SingleChildScrollView(
            child: SizedBox(
              width: 250,
              height: 150,
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
                  _DateField(label: state.formattedRange, initial: state.range),
                ],
              ),
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

class _DateField extends StatefulWidget {
  final String label;
  final DateTimeRange? initial;

  const _DateField({required this.initial, required this.label});

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kIsWeb ? 8 : 16),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.label),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                initialDateRange: widget.initial,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (!mounted) return;
              context.read<FiltersBloc>().add(ChangeRangeEvent(range));
            },
          ),
        ],
      ),
    );
  }
}
