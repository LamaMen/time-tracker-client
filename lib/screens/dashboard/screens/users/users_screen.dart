import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/widget_with_top_loader.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/widgets/actions_bar.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/widgets/users_table.dart';

class UsersScreen extends StatefulWidget implements AutoRouteWrapper {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (c) => getIt<UsersBloc>(),
      child: this,
    );
  }
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    context.read<UsersBloc>().add(const LoadUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: BlocConsumer<UsersBloc, UsersState>(
        listenWhen: (_, state) => state is EditUsersFailureState,
        listener: (_, state) {
          final message = (state as EditUsersFailureState).failure.message;

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
        builder: (context, state) {
          final failure = state is FetchFailedState ? state.failure : null;
          final isLoading = state is LoadUserState;

          return WidgetWithTopLoader(
            isLoading: isLoading,
            failure: failure,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is UsersLoadedState) ...[
                  ActionsBar(
                    users: state.users.entries
                        .where((u) => u.value)
                        .map((u) => u.key)
                        .toList(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: UsersTable(users: state.users),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
