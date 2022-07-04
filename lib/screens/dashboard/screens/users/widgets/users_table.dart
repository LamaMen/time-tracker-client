import 'package:flutter/material.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';

class UsersTable extends StatelessWidget {
  final List<User> users;

  const UsersTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 28,
      showCheckboxColumn: true,
      headingRowColor: MaterialStateProperty.all(
        const Color.fromRGBO(250, 250, 250, 1),
      ),
      border: TableBorder.symmetric(
        outside: const BorderSide(color: Color.fromRGBO(220, 220, 220, 1)),
      ),
      columns: const <DataColumn>[
        DataColumn(label: Text('Сотрудник')),
      ],
      rows: users.map((u) => _UserRow(u, context)).toList(),
    );
  }
}

class _UserRow extends DataRow {
  _UserRow(User user, BuildContext context)
      : super(
          color: MaterialStateProperty.all(Colors.white),
          onSelectChanged: (s) {},
          cells: <DataCell>[
            DataCell(SizedBox(
              height: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.surname} ${user.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.role.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ))
          ],
        );
}
