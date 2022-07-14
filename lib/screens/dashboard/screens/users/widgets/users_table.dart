import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/data/models/auth/full_user.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/bloc/bloc.dart';

class UsersTable extends StatelessWidget {
  final Map<FullUser, bool> users;

  const UsersTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 28,
      headingRowColor: MaterialStateProperty.all(
        const Color.fromRGBO(250, 250, 250, 1),
      ),
      border: TableBorder.symmetric(
        outside: const BorderSide(color: Color.fromRGBO(220, 220, 220, 1)),
      ),
      columns: const <DataColumn>[
        DataColumn(label: Text('Сотрудник')),
      ],
      rows: users.entries.map((u) => _UserRow(u, context)).toList(),
    );
  }
}

class _UserRow extends DataRow {
  _UserRow(MapEntry<FullUser, bool> user, BuildContext context)
      : super(
          selected: user.value,
          color: MaterialStateProperty.all(Colors.white),
          onSelectChanged: (s) {
            context
                .read<UsersBloc>()
                .add(SelectUserEvent(user.key, s ?? false));
          },
          cells: <DataCell>[
            DataCell(SizedBox(
              height: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.key.surname} ${user.key.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.key.role.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ))
          ],
        );
}
