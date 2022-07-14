import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/bloc/bloc.dart';

class AddProjectButton extends StatelessWidget {
  final bool isActive;

  const AddProjectButton({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (context) => const _AddProjectDialog(),
          ).then((name) {
            if (name != null && name.isNotEmpty) {
              context.read<ProjectsBloc>().add(AddProjectEvent(name));
            }
          });
        },
        child: Row(
          children: const [
            Icon(Icons.add, color: Colors.white),
            Text(
              'Создать проект',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddProjectDialog extends StatefulWidget {
  const _AddProjectDialog();

  @override
  State<_AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<_AddProjectDialog> {
  final nameController = TextEditingController();
  bool isControllerEmpty = true;

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {
        isControllerEmpty = nameController.text.isEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Введите имя проекта'),
      content: TextField(
        controller: nameController,
        maxLines: 1,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Закрыть'),
        ),
        TextButton(
          onPressed: !isControllerEmpty
              ? () => Navigator.of(context).pop(nameController.text)
              : null,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
