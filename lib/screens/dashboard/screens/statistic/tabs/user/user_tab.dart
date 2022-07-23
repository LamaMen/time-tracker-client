import 'package:flutter/material.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';

class UserTab extends StatelessWidget {
  final User user;

  const UserTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Info about $user'));
  }
}
