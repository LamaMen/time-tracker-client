import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/theme/dimensions.dart';
import 'package:time_tracker_client/core/widgets/dropdown_widget.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/screens/login/bloc/bloc.dart';
import 'package:time_tracker_client/screens/login/widgets/enter_button.dart';
import 'package:time_tracker_client/screens/login/widgets/error_title.dart';
import 'package:time_tracker_client/screens/login/widgets/password_field.dart';

class LoginScreen extends StatelessWidget implements AutoRouteWrapper {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 2,
            horizontal: defaultPadding * 4,
          ),
          width: 300,
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(defaultRadius),
            ),
          ),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is FetchFailedState) {
                return _FailureState(state: state);
              }

              if (state is SelectUserState) {
                return _SelectUserState(state: state);
              }

              return const _LoadState();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadState extends StatelessWidget {
  const _LoadState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _FailureState extends StatelessWidget {
  final FetchFailedState state;

  const _FailureState({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44,
        child: Column(
          children: [
            Text(state.failure.message),
            TextButton(
              onPressed: () =>
                  context.read<LoginBloc>().add(const FetchUsers()),
              child: const Text('Обновить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectUserState extends StatefulWidget {
  final SelectUserState state;

  const _SelectUserState({Key? key, required this.state}) : super(key: key);

  @override
  State<_SelectUserState> createState() => _SelectUserStateState();
}

class _SelectUserStateState extends State<_SelectUserState> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<LoginBloc>().add(ChangePassword(_controller.text));
    });
  }

  bool get _isCanLogin =>
      widget.state.currentUser != null && widget.state.password.isNotEmpty;

  String? get _errorMessage {
    if (widget.state is LoadTokenFailedState) {
      return (widget.state as LoadTokenFailedState).failure.message;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Вход', style: Theme.of(context).textTheme.headline6),
        const Spacer(),
        DropdownWidget<User>(
          currentElement: widget.state.currentUser,
          hintText: 'Выбирете пользователя',
          elements: widget.state.users,
          onChanged: (value) {
            _controller.clear();
            context.read<LoginBloc>().add(ChangeUser(value));
          },
          isExpanded: true,
        ),
        PasswordField(
          controller: _controller,
          isUserSelected: widget.state.currentUser != null,
        ),
        const Spacer(),
        ErrorTitle(errorMessage: _errorMessage),
        const SizedBox(height: defaultPadding),
        EnterButton(
          enabled: _isCanLogin,
          isLoad: widget.state is LoadTokenState,
        ),
      ],
    );
  }
}
