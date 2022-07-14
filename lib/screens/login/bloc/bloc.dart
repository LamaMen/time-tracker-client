import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/auth/user_credentials.dart';
import 'package:time_tracker_client/domain/repository/auth/auth_repository.dart';
import 'package:time_tracker_client/domain/repository/auth/users_repository.dart';

part 'event.dart';
part 'state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UsersRepository userRepository;
  final AuthRepository loginRepository;

  LoginBloc(this.userRepository, this.loginRepository)
      : super(const FetchUserState()) {
    on<FetchUsers>(onFetchUsers);
    on<ChangeUser>(onChangeUser);
    on<ChangePassword>(onChangePassword);
    on<TryLogin>(onTryLogin);

    add(const FetchUsers());
  }

  Future<void> onFetchUsers(FetchUsers event, Emitter<LoginState> emit) async {
    emit(const FetchUserState());
    final users = await userRepository.fetchUsers();
    emit(users.fold(
      (f) => FetchFailedState(f),
      (u) => SelectUserState.onLoaded(u),
    ));
  }

  Future<void> onTryLogin(TryLogin event, Emitter<LoginState> emit) async {
    if (state is! SelectUserState) return;
    final current = state as SelectUserState;

    if (current.currentUser == null || current.password.isEmpty) return;
    emit(LoadTokenState(current));

    final token = await loginRepository.login(current.credentials);
    emit(token.fold(
      (f) => LoadTokenFailedState(f, state as SelectUserState),
      (_) => LoginSuccessfulState(state as SelectUserState),
    ));
  }

  void onChangeUser(ChangeUser event, Emitter<LoginState> emit) {
    if (state is! SelectUserState) return;
    final current = state as SelectUserState;
    emit(current.changeCurrentUser(event.user));
  }

  void onChangePassword(ChangePassword event, Emitter<LoginState> emit) {
    if (state is! SelectUserState) return;
    final current = state as SelectUserState;
    emit(current.changePassword(event.password));
  }
}
