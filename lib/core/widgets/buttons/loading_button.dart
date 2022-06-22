import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/widgets/buttons/simple_button.dart';
import 'package:time_tracker_client/core/widgets/circular_loader.dart';

class LoadingButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final bool isLoad;
  final VoidCallback? onPressed;

  const LoadingButton({
    Key? key,
    this.width,
    this.height,
    required this.text,
    required this.onPressed,
    required this.isLoad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      width: width,
      height: height,
      onPressed: onPressed,
      child: isLoad
          ? const CircularLoader(size: 25, color: Colors.white)
          : Text(text, style: const TextStyle(fontSize: 20)),
    );
  }
}
