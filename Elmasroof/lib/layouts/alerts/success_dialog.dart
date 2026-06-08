import 'dart:ui';

import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showSuccessDialog({
  required BuildContext context,
  required String message,
  VoidCallback? onDismiss,
}){
  if(FocusScope.of(context).hasFocus){
    FocusScope.of(context).unfocus();
  }
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation){
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ConstAssetImages.success.path, fit: BoxFit.contain, width: 80.0, height: 80.0,),
                  const SizedBox(height: 16.0,),
                  Text(message, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        );
      },
      barrierLabel: 'success dialog',
      barrierDismissible: false,
  );
  Future.delayed(const Duration(seconds: 2,), (){
    if(context.mounted){
      Navigator.of(context, rootNavigator: true).pop(true);
      if(onDismiss != null) {
        onDismiss();
      }}
  },);
}