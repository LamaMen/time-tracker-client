import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/widgets/responsive_utils.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/leading.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/route_widget.dart';

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
    return Drawer(
      width: context.isDesktop ? 72 : null,
      elevation: 0,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            const Leading(),
            for (int i = 0; i < screens.length; i += 1)
              RouteWidget(
                destination: screens[i],
                isSelected: i == selectedIndex,
              ),
          ],
        ),
      ),
    );
  }
}
