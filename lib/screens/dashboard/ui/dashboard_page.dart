import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/main_page.dart';

class DashboardScreen extends StatefulWidget implements AutoRouteWrapper {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: this,
    );
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(const GetUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (_, state) => state is LogOutState,
        listener: (context, state) =>
            context.router.replaceAll([const LoginRoute()]),
        builder: (context, state) {
          if (state is UserState) {
            return AutoRouter(
              builder: (context, child) => MainPage(child: child),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
