import 'dart:ui';

import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:flutter/material.dart';

void showPunishChildAlert({
  required BuildContext context,
  required ChildModel child,
}){
  TextEditingController daysController = TextEditingController()..text = '0';
  GlobalKey<FormFieldState> daysKey = GlobalKey();
  FocusNode daysNode = FocusNode();
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  createTextField(
                    title: 'مدة العقوبة (بالأيام)',
                    hint: 'أدخل المدة',
                    inputType: TextInputType.number,
                    controller: daysController,
                    formKey: daysKey,
                    node: daysNode,
                    formatter: PositiveFormatter(),
                    validator: (String value){
                      if(value.isEmpty) {
                        return 'أدخل مدة العقوبة أولاً';
                      }
                      if(!PositiveFormatter().patternFormatter().hasMatch(value)){
                        return 'أدخل رقم صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  createButton(
                    text: 'إضافة العقوبة',
                    onPressed: () {
                      if(daysKey.currentState!.validate()) {
                        child.punishmentUntil = (child.punishmentUntil ?? DateTime.now())
                            .add(Duration(days: int.parse(daysController.text)));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      barrierLabel: 'determine punish duration child alert',
      barrierDismissible: true
  );
}