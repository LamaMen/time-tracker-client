import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/user_utils.dart';

class Leading extends StatefulWidget {
  const Leading({
    Key? key,
  }) : super(key: key);

  @override
  State<Leading> createState() => _LeadingState();
}

class _LeadingState extends State<Leading> {
  @override
  Widget build(BuildContext context) {
    final user = context.user;

    return Container(
      padding: const EdgeInsets.all(16),
      height: 72,
      color: Theme.of(context).primaryColorDark,
      child: GestureDetector(
        onTap: () async {
          final isExit = await showDialog<bool>(
              context: context, builder: (_) => const _ExitDialog());

          if (isExit == true) {
            if (!mounted) return;
            context.read<AuthBloc>().add(const LogOutEvent());
          }
        },
        child: Tooltip(
          message: 'Выход',
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                user.shortName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выход'),
      content: const Text('Вы уверены что хотите выйти?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Нет'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Да'),
        ),
      ],
    );
  }
}
