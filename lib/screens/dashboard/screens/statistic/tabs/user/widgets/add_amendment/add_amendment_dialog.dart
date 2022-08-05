import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';
import 'package:time_tracker_client/core/widgets/circular_loader.dart';
import 'package:time_tracker_client/core/widgets/dropdown_widget.dart';
import 'package:time_tracker_client/data/models/project/project.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/add_amendment/bloc/bloc.dart';

class AddAmendmentDialog extends StatefulWidget {
  final DateTimeRange range;

  const AddAmendmentDialog({super.key, required this.range});

  @override
  State<AddAmendmentDialog> createState() => AddAmendmentDialogState();
}

class AddAmendmentDialogState extends State<AddAmendmentDialog> {
  final minutesController = TextEditingController();
  final hoursController = TextEditingController();

  @override
  void initState() {
    final bloc = context.read<AddAmendmentBloc>();
    bloc.add(const GetItemsEvent());

    hoursController.text = '0';
    hoursController.addListener(() {
      bloc.add(ChangeHoursEvent(int.tryParse(hoursController.text)));
    });

    minutesController.text = '0';
    minutesController.addListener(() {
      bloc.add(ChangeMinutesEvent(int.tryParse(minutesController.text)));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Исправление прогресса'),
      content: SizedBox(
        width: 250,
        height: 255,
        child: BlocBuilder<AddAmendmentBloc, AddAmendmentState>(
          builder: (context, state) {
            if (state is SelectItemsState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Field(
                    label: 'Проект:',
                    field: DropdownWidget<Project>(
                      hintText: 'Выберете проект',
                      elements: state.projects,
                      currentElement: state.project,
                      onChanged: (project) {
                        context
                            .read<AddAmendmentBloc>()
                            .add(ChangeProjectEvent(project));
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Field(
                    label: 'День:',
                    field: _DateField(state.date, widget.range),
                  ),
                  const SizedBox(height: 5),
                  _Field(
                    label: 'Часы:',
                    field: TextField(
                      keyboardType: TextInputType.number,
                      controller: hoursController,
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Field(
                    label: 'Минуты:',
                    field: TextField(
                      keyboardType: TextInputType.number,
                      controller: minutesController,
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Field(
                    label: 'Прибавлять:',
                    field: Checkbox(
                      value: state.isPositive,
                      onChanged: (isPositive) {
                        context
                            .read<AddAmendmentBloc>()
                            .add(ChangePositivesEvent(isPositive));
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is LoadFailedState) {
              return Center(child: Text(state.failure.message));
            }

            return const Center(child: CircularLoader());
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Закрыть'),
        ),
        BlocBuilder<AddAmendmentBloc, AddAmendmentState>(
          builder: (context, state) {
            return TextButton(
              onPressed: !state.isReady
                  ? null
                  : () {
                      final s = state as SelectItemsState;
                      Navigator.of(context).pop(s.amendment);
                    },
              child: const Text('Сохранить'),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    minutesController.dispose();
    hoursController.dispose();
    super.dispose();
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget field;

  const _Field({required this.label, required this.field});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        Expanded(child: field),
      ],
    );
  }
}

class _DateField extends StatefulWidget {
  final DateTime? date;
  final DateTimeRange range;

  const _DateField(this.date, this.range);

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: widget.date != null
              ? Text(dateFormatter.format(widget.date!))
              : const Text('Не выбрано'),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: widget.range.start,
              firstDate: widget.range.start,
              lastDate: widget.range.end,
            );

            if (!mounted) return;
            context.read<AddAmendmentBloc>().add(ChangeDateEvent(date));
          },
        ),
      ],
    );
  }
}
