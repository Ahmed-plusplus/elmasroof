import 'dart:ui';

import 'package:elmasroof/layouts/ads/interstitial_ad_screen.dart';
import 'package:elmasroof/layouts/custom_widget/radio_group/horizontal_radio_group.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/enums/parent_type.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/remote/firebase/firebase_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showUnlinkChildrenAlert({
  required BuildContext context,
  required List<ChildModel> children,
  required InterstitialAdScreen adScreen,
  VoidCallback? onDismiss,
}){
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      return _createDialog(context, children, adScreen, onDismiss);
    },
    barrierLabel: 'unlink children alert',
    barrierDismissible: true,
  );
}

Widget _createDialog(BuildContext context, List<ChildModel> children, InterstitialAdScreen adScreen, VoidCallback? onDismiss)
=> Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, children, adScreen, onDismiss),
    ),
  ),
);

Widget _createBody(BuildContext context, List<ChildModel> children, InterstitialAdScreen adScreen, VoidCallback? onDismiss) {
  Set<String> selectedChildren = {};
  Set<ChildModel> childrenList = {};
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('اختر الأطفال الذين تريد الغاء ارتباطهم بأى حساب آخر',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const SizedBox(height: 16.0,),
      Column(
        children: childrenList.map((child) {
          ValueNotifier<bool> isSelected = ValueNotifier(selectedChildren.contains(child.name));
          return ValueListenableBuilder<bool>(
            valueListenable: isSelected,
            builder: (context, value, childWidget) {
              return CheckboxListTile(
                title: childWidget,
                value: value,
                onChanged: (bool? value) {
                  if (value == true) {
                    selectedChildren.add(child.name);
                  } else {
                    selectedChildren.remove(child.name);
                  }
                  isSelected.value = value ?? false;
                },
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(child.stickerPath, fit: BoxFit.contain,
                  width: 40, height: 40,),
                const SizedBox(width: 8.0,),
                Text(child.name),
              ],
            ),
          );
        }).toList(),
      ),
      createButton(
          text: 'تأكيد',
          icon: Icons.check,
          width: 100.0,
          horizontalPadding: 8.0,
          onPressed: () {
            adScreen.start(() {
              List<ChildModel> selectedChildrenList = childrenList.where((child) => selectedChildren.contains(child.name)).toList();
              HiveStorage hiveStorage = HiveStorage();
              selectedChildrenList.forEach((child) {
                FirebaseHandler.instance.unlinkChild(SharedManager.getData(key: SharedManager.USER_ID), child);
                child.otherParentId = null;
                hiveStorage.put(child.name, child);
              });

              Navigator.of(context).pop(true);

              onDismiss?.call();
            });
          }
      )
    ],
  );
}