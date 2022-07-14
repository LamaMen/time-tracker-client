import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';

part 'event.dart';

part 'state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const LoadUserState()) {
    on<GetUserEvent>(onGetUser);
    on<LogOutEvent>(onLogOut);
  }

  Future<void> onGetUser(GetUserEvent event, Emitter<AuthState> emit) async {
    final user = await authRepository.getCurrentUser();
    emit(UserState(user));
  }

  Future<void> onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logOut();
    emit(const LogOutState());
  }
}
