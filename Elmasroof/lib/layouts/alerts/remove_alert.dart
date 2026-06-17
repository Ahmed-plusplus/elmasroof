import 'dart:ui';

import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';

void showRemoveAlert({
  required BuildContext context,
  required VoidCallback onSuccess,
}){
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      return _createDialog(context, onSuccess);
    },
    barrierLabel: 'remove alert',
    barrierDismissible: true,
  );
}

Widget _createDialog(BuildContext context, VoidCallback onSuccess) => Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, onSuccess),
    ),
  ),
);

Widget _createBody(BuildContext context, VoidCallback onSuccess) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.highlight_remove, color: Colors.red, size: 80.0,),
    const SizedBox(height: 16.0,),
    const Text('هل تريد الحذف؟', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
    const SizedBox(height: 24.0,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _acceptButton(context, onSuccess),
        _rejectButton(context),
      ],
    ),
  ],
);

Widget _rejectButton(BuildContext context) => Expanded(
  child: createButton(
      text: 'لا',
      icon: Icons.close,
      width: 100.0,
      horizontalPadding: 8.0,
      backgroundColor: Colors.redAccent,
      onPressed: (){
        Navigator.of(context).pop(true);
      }
  ),
);

Widget _acceptButton(BuildContext context, VoidCallback onSuccess) => Expanded(
  child: createButton(
      text: 'نعم',
      icon: Icons.check,
      width: 100.0,
      horizontalPadding: 8.0,
      onPressed: (){
        Navigator.of(context).pop(true);
        onSuccess();
      }
  ),
);