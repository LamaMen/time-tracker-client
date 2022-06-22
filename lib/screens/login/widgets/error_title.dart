import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/theme/dimensions.dart';

class ErrorTitle extends StatelessWidget {
  final String? _errorMessage;

  const ErrorTitle({Key? key, required errorMessage})
      : _errorMessage = errorMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: defaultPadding * 2,
      child: _errorMessage != null
          ? Text(_errorMessage!, style: const TextStyle(color: Colors.red))
          : null,
    );
  }
}
