import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/leading.dart';

class SideNavigation extends StatelessWidget {
  final List<RouteDestination> screens;
  final int selectedIndex;

  const SideNavigation({
    Key? key,
    required this.screens,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 72,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          const Leading(),
          for (int i = 0; i < screens.length; i += 1)
            _RouteWidget(
              destination: screens[i],
              isSelected: i == selectedIndex,
            ),
        ],
      ),
    );
  }
}

class _RouteWidget extends StatelessWidget {
  final RouteDestination destination;
  final bool isSelected;

  const _RouteWidget({
    required this.destination,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => context.navigateTo(destination.route),
          child: isSelected
              ? _ActiveRoute(destination: destination)
              : _PassiveRoute(destination: destination),
        ),
      ),
    );
  }
}

class _ActiveRoute extends StatelessWidget {
  final RouteDestination destination;

  const _ActiveRoute({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(destination.icon),
      ),
    );
  }
}

class _PassiveRoute extends StatefulWidget {
  final RouteDestination destination;

  const _PassiveRoute({required this.destination});

  @override
  State<_PassiveRoute> createState() => _PassiveRouteState();
}

class _PassiveRouteState extends State<_PassiveRoute> {
  bool isHovered = false;

  Color get color => isHovered ? Colors.white : Colors.white54;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: color,
          ),
        ),
        child: Center(
          child: Icon(
            widget.destination.icon,
            color: color,
          ),
        ),
      ),
    );
  }
}

class RouteDestination {
  final PageRouteInfo route;
  final IconData icon;
  final String label;
  final UserRole privacy;

  const RouteDestination({
    required this.route,
    required this.icon,
    required this.label,
    this.privacy = UserRole.employee,
  });
}
