import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/domain/repository/auth/login_repository.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  final AuthRepository authRepository;

  AuthGuard(this.authRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    authRepository
        .getCurrentUserOrNull()
        .then((user) => resolver.next(user != null));
  }
}
