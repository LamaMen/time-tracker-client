import 'package:flutter/material.dart';

class ErrorTitle extends StatelessWidget {
  final String? _errorMessage;

  const ErrorTitle({Key? key, required errorMessage})
      : _errorMessage = errorMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: _errorMessage != null
          ? Text(_errorMessage!, style: const TextStyle(color: Colors.red))
          : null,
    );
  }
}
