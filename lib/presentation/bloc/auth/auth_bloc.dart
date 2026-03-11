import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  }) : super(const AuthInitialState()) {
    on<AuthCheckSessionEvent>(_onCheckSession);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<void> _onCheckSession(
    AuthCheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await getCachedUserUseCase();
    result.fold(
      (failure) => emit(const AuthUnauthenticatedState()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticatedState(user: user));
        } else {
          emit(const AuthUnauthenticatedState());
        }
      },
    );
  }

  Future<void> _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    final result = await loginUseCase(
      username: event.username,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthAuthenticatedState(user: user)),
    );
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(const AuthUnauthenticatedState()),
    );
  }
}
