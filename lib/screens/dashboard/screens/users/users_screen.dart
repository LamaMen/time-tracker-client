import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/top_loader.dart';
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
      padding: const EdgeInsets.all(36),
      child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
        final failure = state is FetchFailedState ? state.failure : null;
        final isLoading = state is LoadUserState;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopLoader(isLoading: isLoading, failure: failure),
              if (state is UsersLoadedState) ...[
                const ActionsBar(countSelectedItems: 0),
                UsersTable(users: state.users),
              ]
            ],
          ),
        );
      }),
    );
  }
}
