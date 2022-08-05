import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/amendment.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/add_amendment/add_amendment_dialog.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/user/widgets/add_amendment/bloc/bloc.dart';

class AddAmendmentButton extends StatelessWidget {
  final bool isActive;
  final User? user;
  final DateTimeRange range;

  const AddAmendmentButton({
    super.key,
    required this.isActive,
    required this.user,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 211,
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
          showDialog<Amendment>(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (_) => getIt<AddAmendmentBloc>(),
                child: AddAmendmentDialog(range: range),
              );
            },
          ).then((a) {
            if (a != null) {
              final amendment = Amendment(
                -1,
                a.date,
                a.projectId,
                a.hours,
                a.minutes,
                a.isPositive,
                user!.id,
              );
              context.read<ProgressBloc>().add(AddAmendmentEvent(amendment));
            }
          });
        },
        child: Row(
          children: const [
            Icon(Icons.edit, color: Colors.white),
            Text(
              'Исправить неточность',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
