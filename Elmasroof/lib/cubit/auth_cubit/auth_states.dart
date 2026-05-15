abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthPasswordReadyState extends AuthStates {}

class AuthStartedState extends AuthStates {}
class AuthSuccessState extends AuthStates {}
class AuthErrorState extends AuthStates {
  final String error;
  AuthErrorState(this.error);
}