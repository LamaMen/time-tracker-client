import 'package:flutter/material.dart';

class ActionsBar extends StatelessWidget {
  final int countSelectedItems;

  const ActionsBar({super.key, required this.countSelectedItems});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 32,
      child: ToggleButtons(
        color: Colors.black.withOpacity(0.60),
        selectedColor: color,
        selectedBorderColor: color,
        fillColor: color.withOpacity(0.08),
        splashColor: color.withOpacity(0.12),
        hoverColor: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4.0),
        isSelected: const [false, false, false],
        onPressed: (index) {},
        children: const [
          Icon(Icons.add, size: 20),
          Icon(Icons.delete, size: 20),
          Icon(Icons.edit, size: 20),
        ],
      ),
    );
  }
}
