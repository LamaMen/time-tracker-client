import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/dashboard/bloc/bloc.dart';

class SideNavigation extends StatelessWidget {
  final List<RouteDestination> destinations;
  final int selectedIndex;
  final User user;

  const SideNavigation({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 72,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          _Leading(user: user),
          for (int i = 0; i < destinations.length; i += 1)
            _RouteWidget(
              destination: destinations[i],
              isSelected: i == selectedIndex,
            ),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  final User user;

  const _Leading({Key? key, required this.user}) : super(key: key);

  String get usernameShort =>
      user.name.toUpperCase().substring(0, 1) +
      user.surname.toUpperCase().substring(0, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 72,
      color: Theme.of(context).primaryColorDark,
      child: GestureDetector(
        onTap: () => showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Выход'),
              content: const Text('Вы уверены что хотите выйти?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Нет'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Да'),
                ),
              ],
            );
          },
        ).then((isExit) {
          if (isExit == true) {
            context.read<AuthBloc>().add(const LogOutEvent());

          }
        }),
        child: Tooltip(
          message: 'Выход',
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                usernameShort,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
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
