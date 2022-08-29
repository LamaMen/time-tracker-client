import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';

@singleton
class AdminGuard extends AutoRouteGuard {
  final AuthRepository authRepository;

  AdminGuard(this.authRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await authRepository.getToken();

    if (token == null || token.isExpired) {
      router.push(const LoginRoute());
    }

    final user = await authRepository.getCurrentUser();
    if (user.role == UserRole.admin) {
      resolver.next(true);
    } else {
      router.push(const DashboardRoute());
    }
  }
}
