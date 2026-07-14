import 'package:local_auth/local_auth.dart';

class BiometricAvailability {

  static final BiometricAvailability _instance = BiometricAvailability._(false, []);

  static BiometricAvailability get instance => _instance;

  bool isSupported;
  List<BiometricType> availableBiometric;

  BiometricAvailability._(this.isSupported, this.availableBiometric);
}