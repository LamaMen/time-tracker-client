import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/app_bar.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/side_navigation.dart';

class DashboardScreen extends StatefulWidget implements AutoRouteWrapper {
  final destinations = [
    const RouteDestination(
      route: TrackingRoute(),
      icon: Icons.timer_outlined,
      label: 'Отслеживание времени',
    ),
    const RouteDestination(
      route: StatisticRoute(),
      icon: Icons.info_outline_rounded,
      label: 'Статистика',
    ),
    const RouteDestination(
      route: UsersRoute(),
      icon: Icons.person,
      label: 'Пользователи',
      privacy: UserRole.admin,
    ),
  ];

  DashboardScreen({Key? key}) : super(key: key);

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
            var destinations = widget.destinations
                .where((d) => state.user.role.isCanAccess(d.privacy))
                .toList();

            return AutoRouter(builder: (context, child) {
              var selectedIndex = destinations.indexWhere(
                (d) => context.router.isRouteActive(d.route.routeName),
              );

              if (selectedIndex == -1) {
                selectedIndex = 0;
              }

              return Row(
                children: [
                  SideNavigation(
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    user: state.user,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TopBar(label: destinations[selectedIndex].label),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              );
            });
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
