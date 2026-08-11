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

void showSelectChildrenAlert({
  required BuildContext context,
  required List<ChildModel> yourChildren,
  required List<ChildModel> otherChildren,
  required String otherParentId,
  required InterstitialAdScreen adScreen,
  VoidCallback? onDismiss,
}){
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      return _createDialog(context, yourChildren, otherChildren, otherParentId, adScreen, onDismiss);
    },
    barrierLabel: 'select children alert',
    barrierDismissible: false,
  );
}

Widget _createDialog(BuildContext context, List<ChildModel> yourChildren, List<ChildModel> otherChildren, String otherParentId, InterstitialAdScreen adScreen, VoidCallback? onDismiss)
=> Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, yourChildren, otherChildren, otherParentId, adScreen, onDismiss),
    ),
  ),
);

Widget _createBody(BuildContext context, List<ChildModel> yourChildren, List<ChildModel> otherChildren, String otherParentId, InterstitialAdScreen adScreen, VoidCallback? onDismiss) {
  ParentType yourType = SharedManager.getData(key: SharedManager.PARENT_TYPE) ?? ParentType.father;
  ValueNotifier<ParentType> selectedParentType = ValueNotifier(yourType);
  Set<String> selectedChildren = {};
  Set<ChildModel> childrenList = {};
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('اختر الأطفال الذين تريد ربطهم بالحساب الآخر',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const SizedBox(height: 16.0,),
      ValueListenableBuilder<ParentType>(
        valueListenable: selectedParentType,
        builder: (context, value, child) {
          childrenList.clear();
          childrenList.addAll(value == yourType ? yourChildren : otherChildren);
          childrenList.addAll(value == yourType ? otherChildren : yourChildren);
          bool conflictExist = childrenList.length != yourChildren.length + otherChildren.length;
          return Column(
            children: [
              if(conflictExist)
                Column(
                  children: [
                    Text('هناك أطفال بنفس الاسم في الحسابين، حدد نوع الدمج فى اختيار الأطفال',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    HorizontalRadioGroup<String>(
                        list: ['أطفالى', 'أطفال الحساب الآخر'],
                        callBack: (String? newValue) {
                          if (newValue != null) {
                            selectedParentType.value =
                            newValue == 'أطفالى' ? yourType : (yourType == ParentType.father
                                ? ParentType.mother
                                : ParentType.father);
                          }
                        }
                    ),
                    const SizedBox(height: 8.0,),
                  ],
                ),
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
            ],
          );
        },
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
                child.otherParentId = otherParentId;
                hiveStorage.put(child.name, child);
              });

              FirebaseHandler.instance.linkParents(SharedManager.getData(key: SharedManager.USER_ID), otherParentId, selectedChildrenList);

              Navigator.of(context).pop(true);

              onDismiss?.call();
            });
          }
      )
    ],
  );
}