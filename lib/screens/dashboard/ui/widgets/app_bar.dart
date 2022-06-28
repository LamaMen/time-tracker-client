import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String label;

  const TopBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.grey[300]!),
        ),
      ),
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
