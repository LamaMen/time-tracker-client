import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/widgets/provider.dart';
import 'package:time_tracker_client/core/widgets/responsive_utils.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/navigation_controller.dart';

class RouteWidget extends StatelessWidget {
  final RouteDestination destination;
  final bool isSelected;

  const RouteWidget({
    super.key,
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
          onTap: () {
            context.notListenProvider<NavigationController>().close();
            context.navigateTo(destination.route);
          },
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
      child: _RouteContent(
        icon: destination.icon,
        label: destination.label,
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
        child: _RouteContent(
          icon: widget.destination.icon,
          label: widget.destination.label,
          color: color,
        ),
      ),
    );
  }
}

class _RouteContent extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String label;

  const _RouteContent({
    this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final width = DrawerTheme.of(context).width;

    return ResponsiveWidget(
      mobile: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, color: color),
            ),
            Text(label, style: TextStyle(color: color))
          ],
        ),
      ),
      desktop: Center(child: Icon(icon, color: color)),
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
