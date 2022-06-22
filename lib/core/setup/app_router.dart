import 'package:auto_route/auto_route.dart';
import 'package:time_tracker_client/screens/login/login_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginScreen, initial: true),
  ],
)
class $AppRouter {}