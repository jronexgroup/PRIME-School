import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthRegister>(_onRegister);
    on<AuthLogin>(_onLogin);
    on<AuthSignedOut>(_onAuthSignedOut);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.registerWithEmail(
        event.email,
        event.password,
        event.name,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signInWithEmail(
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthSignedOut(AuthSignedOut event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(Unauthenticated());
  }

  void _onAuthUserUpdated(AuthUserUpdated event, Emitter<AuthState> emit) {
    emit(Authenticated(event.user));
  }
}
