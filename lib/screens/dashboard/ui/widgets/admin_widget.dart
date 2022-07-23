import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';

extension AdminWidget on Widget {
  Widget onlyAdmin(BuildContext context) {
    final authState = context.read<AuthBloc>().state as UserState;
    final role = authState.user.role;
    return role == UserRole.admin ? this : const SizedBox.shrink();
  }
}
