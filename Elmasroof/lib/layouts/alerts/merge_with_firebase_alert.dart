import 'dart:ui';

import 'package:elmasroof/layouts/ads/interstitial_ad_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';

void showMergeWithFirebaseAlert({
  required BuildContext context,
  required VoidCallback onPreviousChoose,
  required VoidCallback onCurrentChoose,
  required InterstitialAdScreen adScreen,
}){
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      return PopScope(canPop: false, child: _createDialog(context, onPreviousChoose, onCurrentChoose, adScreen));
    },
    barrierLabel: 'merge alert',
    barrierDismissible: false,
  );
}

Widget _createDialog(BuildContext context, VoidCallback onPreviousChoose, VoidCallback onCurrentChoose, InterstitialAdScreen adScreen)
=> Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, onPreviousChoose, onCurrentChoose, adScreen),
    ),
  ),
);

Widget _createBody(BuildContext context, VoidCallback onPreviousChoose, VoidCallback onCurrentChoose, InterstitialAdScreen adScreen)
=> Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.error_outline_rounded, color: Colors.red, size: 80.0,),
    const SizedBox(height: 16.0,),
    const Text('الحساب مسجل مسبقاً. هل تريد استرداد البيانات السابقة أم الاحتفاظ بالحالية؟',
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    const SizedBox(height: 16.0,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _previousButton(context, onPreviousChoose, adScreen),
        _currentButton(context, onCurrentChoose, adScreen),
      ],
    ),
  ],
);

Widget _currentButton(BuildContext context, VoidCallback onCurrentChoose, InterstitialAdScreen adScreen) => Expanded(
  child: createButton(
      text: 'احتفظ',
      icon: Icons.check,
      width: 100.0,
      horizontalPadding: 8.0,
      onPressed: (){
        adScreen.start((){
          onCurrentChoose();
          Navigator.of(context).pop(true);
        });
      }
  ),
);

Widget _previousButton(BuildContext context, VoidCallback onPreviousChoose, InterstitialAdScreen adScreen) => Expanded(
  child: createButton(
      text: 'استرد',
      icon: Icons.sync,
      width: 100.0,
      horizontalPadding: 8.0,
      onPressed: (){
        adScreen.start((){
          onPreviousChoose();
          Navigator.of(context).pop(true);
        });
      }
  ),
);