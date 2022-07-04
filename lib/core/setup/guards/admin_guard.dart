import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';

@singleton
class AdminGuard extends AutoRouteGuard {
  final AuthRepository authRepository;

  AdminGuard(this.authRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    authRepository.getCurrentUserOrNull().then((user) {
      if (user != null) {
        resolver.next(user.role == UserRole.admin);
      } else {
        resolver.next(false);
      }
    });
  }
}
