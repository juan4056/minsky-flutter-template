import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: LoginStatus.error));
    } else {
      emit(state.copyWith(status: LoginStatus.loading));
      await Future.delayed(const Duration(seconds: 3), () {
        emit(state.copyWith(status: LoginStatus.success, username: username));
      });
    }
  }
}
