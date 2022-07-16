part of 'login_cubit.dart';

enum LoginStatus { initial, loading, error, success }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.username = '',
  });

  final LoginStatus status;
  final String username;

  @override
  List<Object> get props => [
        status,
        username,
      ];

  LoginState copyWith({
    LoginStatus? status,
    String? username,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
    );
  }
}
