import 'package:flutter/material.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/usecase/progress/progress_filters.dart';

class UserTab extends StatelessWidget {
  final User user;
  final ProgressFilters filters;

  const UserTab({super.key, required this.user, required this.filters});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Info about $user'));
  }
}
