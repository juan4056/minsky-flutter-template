import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/repositories/auth_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required authRepository})
      : _authRepository = authRepository,
        super(const DashboardState());
  final AuthenticationRepository _authRepository;

  Future<void> logout() async {
    await _authRepository.signOut();
  }
}
