import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/screens/splash/bloc/bloc.dart';

class SplashScreen extends StatefulWidget implements AutoRouteWrapper {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (_) => getIt<SplashBloc>(),
      child: this,
    );
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<SplashBloc>().add(const Initialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is NavigateToLogin) {
                context.router.replace(const LoginRoute());
              } else if (state is NavigateToDashboard) {
                // TODO navigate to dashboard
              }
            });
          },
          child: const Text('Проверка пользователя'),
        ),
      ),
    );
  }
}
