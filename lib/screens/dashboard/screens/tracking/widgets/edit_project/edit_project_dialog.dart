import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/widgets/edit_project/bloc/bloc.dart';

class EditProjectDialog extends StatefulWidget {
  const EditProjectDialog({super.key});

  @override
  State<EditProjectDialog> createState() => EditProjectDialogState();
}

class EditProjectDialogState extends State<EditProjectDialog> {
  final nameController = TextEditingController();

  @override
  void initState() {
    final bloc = context.read<EditProjectBloc>();
    nameController.text = bloc.state.project.name;
    nameController.addListener(() {
      bloc.add(ChangeNameEvent(nameController.text));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProjectBloc, EditProjectState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Редактирование проекта'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 250,
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Название:'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Архивный:'),
                      const SizedBox(width: 8),
                      Checkbox(
                        value: state.project.isArchive,
                        onChanged: (bool? value) {
                          context
                              .read<EditProjectBloc>()
                              .add(ChangeArchiveEvent(value));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Закрыть'),
            ),
            TextButton(
              onPressed: state.project.name.isNotEmpty
                  ? () => Navigator.of(context).pop(state.project)
                  : null,
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
