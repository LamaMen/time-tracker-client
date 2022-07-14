import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/failure/failure.dart';

class TopLoader extends StatelessWidget {
  final Failure? failure;
  final bool isLoading;

  const TopLoader({super.key, this.failure, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final errorMessage = SizedBox(
      height: 16,
      child: Text(
        failure?.message ?? '',
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );

    final loader = isLoading
        ? const SizedBox(height: 8, child: LinearProgressIndicator())
        : const SizedBox(height: 8);

    return SizedBox(
      height: 26,
      child: Column(
        children: [
          errorMessage,
          const SizedBox(height: 2),
          loader,
        ],
      ),
    );
  }
}
