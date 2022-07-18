import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(Uninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    final user = await _authenticationRepository.user();
    if (user != null) {
      emit(Authenticated(displayName: user.name));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    final user = await _authenticationRepository.user();
    if (user != null) {
      emit(Authenticated(displayName: user.name));
    }
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    final user = await _authenticationRepository.user();
    if (user == null) {
      emit(Unauthenticated());
    }
  }
}
