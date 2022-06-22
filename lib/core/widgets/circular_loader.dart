import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final Color? color;

  const CircularLoader({
    Key? key,
    this.size,
    this.strokeWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 4,
        color: color,
      ),
    );
  }
}
