import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthSignedIn extends AuthEvent {}

class AuthSignedOut extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final UserModel user;
  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
