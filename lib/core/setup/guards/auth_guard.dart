import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/setup/app_router.gr.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';

@singleton
class AuthGuard extends AutoRouteGuard {
  final AuthRepository authRepository;

  AuthGuard(this.authRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await authRepository.getToken();
    if (token != null && !token.isExpired) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
