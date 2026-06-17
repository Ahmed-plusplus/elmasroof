import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elmasroof/cubit/auth_cubit/auth_states.dart';
import 'package:local_auth/local_auth.dart';

class AuthCubit extends Cubit<AuthStates> {

  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isPasswordReady = false;
  bool isAuthenticating = false;

  LocalAuthentication auth = LocalAuthentication();

  void showBiometricAuth() {
    isPasswordReady = true;
    emit(AuthPasswordReadyState());
  }

  void hideBiometricAuth() {
    isPasswordReady = false;
    emit(AuthPasswordReadyState());
  }

  Future<void> authenticateWithBiometrics() async {
    var authenticated = false;
    try {
      startAuthenticating();
      authenticated = await _showBiometricAuth();
      isAuthenticating = false;
    } on LocalAuthException catch (e) {
      print(e);
      isAuthenticating = false;
      if (e.code != LocalAuthExceptionCode.userCanceled &&
          e.code != LocalAuthExceptionCode.systemCanceled) {
        emit(AuthErrorState('Error - ${e.code.name}${e.description != null ? ': ${e.description}' : ''}'));
      }
    } on PlatformException catch (e) {
      print(e);
      isAuthenticating = false;
      emit(AuthErrorState('Unexpected Error - ${e.message}'));
    }
    if(authenticated) {
      emit(AuthSuccessState());
    }
  }

  void startAuthenticating() {
    isAuthenticating = true;
    emit(AuthStartedState());
  }

  void stopAuthenticating() {
    isAuthenticating = false;
    emit(AuthStartedState());
  }

  Future<bool> _showBiometricAuth() async{
    return await auth.authenticate(
      localizedReason:
      'سجل الدخول ببصمتك',
      persistAcrossBackgrounding: true,
      biometricOnly: true,
    );
  }

}