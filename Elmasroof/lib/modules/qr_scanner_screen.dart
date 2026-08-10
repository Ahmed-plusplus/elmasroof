import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final barcode = capture.barcodes.first;

          final String? rawValue = barcode.rawValue;

          if (rawValue != null) {
            try {
              final data = jsonDecode(rawValue);

              if (data['type'] == 'link_parent_qr' && data['app'] == 'Elmasroof') {
                print(data['data']);
                Navigator.pop(context, data['data']);
              } else {
                Navigator.pop(context, 'Invalid QR for app');
              }
            } catch (_) {
              Navigator.pop(context, 'Invalid QR format');
            }
          } else {
            Navigator.pop(context, 'No QR detected');
          }
        },
      ),
    );
  }
}