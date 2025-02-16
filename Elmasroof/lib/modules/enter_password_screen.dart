import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class EnterPasswordScreen extends StatefulWidget {
  EnterPasswordScreen({super.key, required this.isSupported, required this.availableBiometric});

  bool isSupported;
  List<BiometricType> availableBiometric;

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El masroof'),
        elevation: 5,
      ),
      body: Container(),
    );
  }
}
