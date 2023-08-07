import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/core/setup/guards/admin_guard.dart';
import 'package:time_tracker_client/core/setup/guards/auth_guard.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/theme/colors.dart';
import 'package:time_tracker_client/core/theme/fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(kDebugMode ? 'dev' : 'prod');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter(
    adminGuard: getIt<AdminGuard>(),
    authGuard: getIt<AuthGuard>(),
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Client',
      theme: ThemeData(
        textTheme: fonts(context),
        primarySwatch: primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
