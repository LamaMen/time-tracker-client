import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/user_utils.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/app_bar.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/side_navigation.dart';

const screens = [
  RouteDestination(
    route: TrackingRoute(),
    icon: Icons.timer_outlined,
    label: 'Отслеживание времени',
  ),
  RouteDestination(
    route: StatisticRoute(),
    icon: Icons.info_outline_rounded,
    label: 'Статистика',
  ),
  RouteDestination(
    route: UsersRoute(),
    icon: Icons.person,
    label: 'Пользователи',
    privacy: UserRole.admin,
  ),
];

class MainPage extends StatelessWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = context.user;
    final s = screens.where((d) => user.role.isCanAccess(d.privacy)).toList();

    var selectedIndex = s.indexWhere(
      (d) => context.router.isRouteActive(d.route.routeName),
    );

    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    return Scaffold(
      body: Row(
        children: [
          SideNavigation(screens: s, selectedIndex: selectedIndex),
          Expanded(
            child: Column(
              children: [
                TopBar(label: s[selectedIndex].label),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
