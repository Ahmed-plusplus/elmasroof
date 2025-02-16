import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class CreateAuthScreen extends StatefulWidget {
  CreateAuthScreen({super.key, required this.isSupported, required this.availableBiometric});

  bool isSupported;
  List<BiometricType> availableBiometric;

  @override
  State<CreateAuthScreen> createState() => _CreateAuthScreenState();
}

class _CreateAuthScreenState extends State<CreateAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El masroof'),
        elevation: 5,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.fingerprint),
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide()),
              padding: WidgetStatePropertyAll(EdgeInsets.all(8.0)),
              elevation: WidgetStatePropertyAll(1.0),
            ),
          ),
          SizedBox(width: 20,),
          IconButton(
            onPressed: () => null,
            icon: Icon(Icons.tag_faces_rounded),
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide()),
              padding: WidgetStatePropertyAll(EdgeInsets.all(8.0)),
              elevation: WidgetStatePropertyAll(1.0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
