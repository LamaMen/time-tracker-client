import 'package:auto_route/auto_route.dart';
import 'package:time_tracker_client/core/setup/guards/admin_guard.dart';
import 'package:time_tracker_client/core/setup/guards/auth_guard.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/statistic_screen.dart';
import 'package:time_tracker_client/screens/dashboard/screens/tracking/tracking_screen.dart';
import 'package:time_tracker_client/screens/dashboard/screens/users/users_screen.dart';
import 'package:time_tracker_client/screens/dashboard/ui/dashboard_page.dart';
import 'package:time_tracker_client/screens/login/login_screen.dart';
import 'package:time_tracker_client/screens/splash/ui/splash_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: LoginScreen),
    AutoRoute(
      path: '/dashboard',
      page: DashboardScreen,
      guards: [AuthGuard],
      children: [
        CustomRoute(
          page: TrackingScreen,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 300,
          initial: true,
        ),
        CustomRoute(
          page: StatisticScreen,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 300,
        ),
        CustomRoute(
          page: UsersScreen,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          guards: [AdminGuard],
          durationInMilliseconds: 300,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
