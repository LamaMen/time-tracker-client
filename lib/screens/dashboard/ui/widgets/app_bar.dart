import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/widgets/provider.dart';
import 'package:time_tracker_client/core/widgets/responsive_utils.dart';
import 'package:time_tracker_client/screens/dashboard/ui/widgets/navigation/navigation_controller.dart';

class TopBar extends StatelessWidget {
  final String label;

  const TopBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final padding = context.isDesktop ? 28.0 : 20.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.grey[300]!),
        ),
      ),
      height: 72,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: context.notListenProvider<NavigationController>().open,
          ).onlyNotDesktop(context),
          Text(
            label,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
