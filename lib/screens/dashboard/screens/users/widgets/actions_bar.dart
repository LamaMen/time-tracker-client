import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/widgets/dropdown_widget.dart';
import 'package:time_tracker_client/data/models/auth/full_user.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/bloc/bloc.dart';

class ActionsBar extends StatelessWidget {
  final List<FullUser> users;

  const ActionsBar({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[const Icon(Icons.add, size: 20)];

    if (users.isNotEmpty) icons.add(const Icon(Icons.delete, size: 20));
    if (users.length == 1) icons.add(const Icon(Icons.edit, size: 20));

    final color = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 32,
      child: ToggleButtons(
        color: Colors.black.withOpacity(0.60),
        selectedColor: color,
        selectedBorderColor: color,
        fillColor: color.withOpacity(0.08),
        splashColor: color.withOpacity(0.12),
        hoverColor: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4.0),
        isSelected: icons.map((_) => false).toList(),
        onPressed: (index) {
          switch (index) {
            case 0:
              openSaveUserDialog(context);
              break;
            case 1:
              openDeleteUsersDialog(context);
              break;
            case 2:
              openSaveUserDialog(context, initial: users.first);
              break;
          }
        },
        children: icons,
      ),
    );
  }

  void openSaveUserDialog(BuildContext context, {FullUser? initial}) {
    showDialog<FullUser>(
      context: context,
      builder: (context) => _SaveUserDialog(initial ?? FullUser.initial()),
    ).then((user) {
      if (user != null) context.read<UsersBloc>().add(EditUserEvent(user));
    });
  }

  void openDeleteUsersDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удаление пользователй'),
          content: const Text(
            'Вы уверены что хотите удалить выделенных пользователей?',
          ),
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
      },
    ).then((r) {
      if (r == true) context.read<UsersBloc>().add(DeleteUsersEvent(users));
    });
  }
}

class _SaveUserDialog extends StatefulWidget {
  final FullUser initial;

  const _SaveUserDialog(this.initial);

  @override
  State<_SaveUserDialog> createState() => _SaveUserDialogState();
}

class _SaveUserDialogState extends State<_SaveUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  late UserRole role;

  @override
  void initState() {
    nameController.text = widget.initial.name;
    surnameController.text = widget.initial.surname;
    passwordController.text = widget.initial.password;
    role = widget.initial.role;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial.id.isEmpty
          ? 'Добавить пользователя'
          : 'Изменить пользователя'),
      content: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SizedBox(
            height: 260,
            width: 250,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(helperText: 'Имя'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите имя' : null,
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: TextFormField(
                    controller: surnameController,
                    decoration: const InputDecoration(helperText: 'Фамилия'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите фамилию' : null,
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(helperText: 'Пароль'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите пароль' : null,
                  ),
                ),
                DropdownWidget<UserRole>(
                  currentElement: role,
                  hintText: 'Роль пользователя',
                  elements: UserRole.values,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) setState(() => role = value);
                  },
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Закрыть'),
        ),
        TextButton(
          onPressed: exit,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  void exit() {
    if (_formKey.currentState!.validate()) {
      final user = FullUser(
        widget.initial.id,
        nameController.text,
        surnameController.text,
        passwordController.text,
        role,
      );

      Navigator.of(context).pop(user);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }
}
