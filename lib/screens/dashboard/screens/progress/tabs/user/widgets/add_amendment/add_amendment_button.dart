import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/buttons/simple_button.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/progress/amendment.dart';
import 'package:time_tracker_client/screens/dashboard/screens/progress/tabs/user/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/progress/tabs/user/widgets/add_amendment/add_amendment_dialog.dart';
import 'package:time_tracker_client/screens/dashboard/screens/progress/tabs/user/widgets/add_amendment/bloc/bloc.dart';

class AddAmendmentButton extends StatefulWidget {
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
  State<AddAmendmentButton> createState() => _AddAmendmentButtonState();
}

class _AddAmendmentButtonState extends State<AddAmendmentButton> {
  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      width: 211,
      height: 36,
      onPressed: widget.isActive ? addAmendment : null,
      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.white),
          Text('Исправить неточность', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<void> addAmendment() async {
    final a = await showDialog<Amendment>(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => getIt<AddAmendmentBloc>(),
          child: AddAmendmentDialog(range: widget.range),
        );
      },
    );

    if (mounted && a != null) {
      final amendment = Amendment(
        -1,
        a.date,
        a.projectId,
        a.hours,
        a.minutes,
        a.isPositive,
        widget.user!.id,
      );
      context.read<ProgressBloc>().add(AddAmendmentEvent(amendment));
    }
  }
}
