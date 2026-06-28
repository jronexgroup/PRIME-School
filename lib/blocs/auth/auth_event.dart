import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  const AuthRegister(this.email, this.password, this.name);

  @override
  List<Object> get props => [email, password, name];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthSignedOut extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final UserModel user;
  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
