import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_app/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  final AuthenticationRepository _authRepository;

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: LoginStatus.error));
      emit(state.copyWith(
          status: LoginStatus.error, errorCode: 'incomplete-fields'));
    } else {
      emit(state.copyWith(status: LoginStatus.loading));
      try {
        await _authRepository.signInWithCredentials(username, password);
        emit(state.copyWith(status: LoginStatus.success, username: username));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(state.copyWith(
              status: LoginStatus.error, errorCode: 'user-not-found'));
        } else if (e.code == 'wrong-password') {
          emit(state.copyWith(
              status: LoginStatus.error, errorCode: 'wrong-password'));
        }
        emit(state.copyWith(status: LoginStatus.error, errorCode: 'unknown'));
      }
    }
  }
}
