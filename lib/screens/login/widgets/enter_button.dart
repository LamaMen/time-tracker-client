import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/widgets/buttons/loading_button.dart';
import 'package:time_tracker_client/screens/login/bloc/bloc.dart';

class EnterButton extends StatelessWidget {
  final bool isLoad;
  final bool enabled;

  const EnterButton({
    Key? key,
    required this.isLoad,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      width: double.infinity,
      height: 40,
      isLoad: isLoad,
      text: 'Войти',
      onPressed: enabled
          ? () => context.read<LoginBloc>().add(const TryLogin())
          : null,
    );
  }
}
