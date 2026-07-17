import 'dart:ui';

import 'package:elmasroof/layouts/ads/interstitial_ad_screen.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/extensions/date_time_extension.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:flutter/material.dart';

TextEditingController daysController = TextEditingController();
GlobalKey<FormFieldState> daysKey = GlobalKey();
FocusNode daysNode = FocusNode();

void showPunishChildAlert({
  required BuildContext context,
  required ChildModel child,
  required InterstitialAdScreen adScreen,
}){
  daysController.text = '0';
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation){
        return _createDialog(context, child, adScreen);
      },
      barrierLabel: 'determine punish duration child alert',
      barrierDismissible: true
  );
}

Widget _createDialog(BuildContext context, ChildModel child, InterstitialAdScreen adScreen) => Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, child, adScreen),
    ),
  ),
);

Widget _createBody(BuildContext context, ChildModel child, InterstitialAdScreen adScreen) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    _createPunishmentTextField(),
    const SizedBox(height: 8,),
    _createPunishmentButton(context, child, adScreen),
  ],
);

Widget _createPunishmentTextField() => createTextField(
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
);

Widget _createPunishmentButton(BuildContext context, ChildModel child, InterstitialAdScreen adScreen)
=> createButton(
  text: 'إضافة العقوبة',
  onPressed: () {
    if(daysKey.currentState!.validate()) {
      adScreen.start((){
        child.punishmentUntil = (child.punishmentUntil ?? DateTime.now().dateOnly())
            .add(Duration(days: int.parse(daysController.text)));
        HiveStorage hiveStorage = HiveStorage();
        hiveStorage.put(child.name, child);
        Navigator.of(context).pop();
      });
    }
  },
);
