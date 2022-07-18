part of 'login_cubit.dart';

enum LoginStatus { initial, loading, error, success }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.username = '',
    this.errorCode = '',
  });

  final LoginStatus status;
  final String username;
  final String errorCode;

  @override
  List<Object> get props => [
        status,
        username,
        errorCode,
      ];

  LoginState copyWith({
    LoginStatus? status,
    String? username,
    String? errorCode,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
