import 'dart:ui';

import 'package:flutter/material.dart';

void showAddChildAlert({
  required BuildContext context,
}){
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        alignment: Alignment.center,
        insetPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
            ],
          ),
        ),
      );
    },
  );
}