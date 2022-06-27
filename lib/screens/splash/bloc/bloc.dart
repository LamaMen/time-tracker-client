import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/domain/repository/auth/login_repository.dart';

part 'event.dart';
part 'state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  SplashBloc(this._authRepository) : super(const InitialState()) {
    on<Initialize>(initial);
  }

  Future<void> initial(
    Initialize event,
    Emitter<SplashState> emit,
  ) async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      emit(const NavigateToLogin());
    } else {
      emit(const NavigateToDashboard());
    }
  }
}
