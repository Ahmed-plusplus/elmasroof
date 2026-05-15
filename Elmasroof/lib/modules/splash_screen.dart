import 'package:elmasroof/modules/create_password_screen.dart';
import 'package:elmasroof/modules/enter_password_screen.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSupported = false;
  List<BiometricType> _availableBiometric = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalAuthentication auth = LocalAuthentication();

    Future.delayed(
        const Duration(seconds: 5),
        () => Future.wait([
              auth.isDeviceSupported(),
              auth.getAvailableBiometrics(),
            ]).then((list) {
              _isSupported = list[0] as bool;
              _availableBiometric = list[1] as List<BiometricType>;
              print('is supported: $_isSupported');
              print('available: $_availableBiometric');
              _navigateScreen();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/jsons/fake_3d_vector_coin.json')),
    );
  }

  void _navigateScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) =>
          (SharedManager.getData(key: SharedManager.LOGIN_PASSWORD) == null)
              ? CreatePasswordScreen(
                  isSupported: _isSupported,
                  availableBiometric: _availableBiometric)
              : EnterPasswordScreen(
                  isSupported: _isSupported,
                  availableBiometric: _availableBiometric),
      // : HomeScreen(),
    ));
  }
}
