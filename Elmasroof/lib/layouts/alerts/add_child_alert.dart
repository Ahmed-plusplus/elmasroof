import 'dart:ui';

import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/formatter/decimal_formatter.dart';
import 'package:flutter/material.dart';

void showAddChildAlert({
  required BuildContext context,
  required HomeCubit cubit,
}){
  TextEditingController nameController = TextEditingController();
  TextEditingController initExpensesController = TextEditingController()..text = '0';
  GlobalKey<FormFieldState> nameKey = GlobalKey();
  GlobalKey<FormFieldState> initExpensesKey = GlobalKey();
  FocusNode nameNode = FocusNode();
  FocusNode initExpensesNode = FocusNode();
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
                  title: 'إسم الإبن/البنت',
                  hint: 'أدخل الإسم',
                  controller: nameController,
                  formKey: nameKey,
                  node: nameNode,
                  action: TextInputAction.next,
                  suffixIcon: Icons.person,
                  validator: (String value){
                    if(value.isEmpty) {
                      return 'أدخل الإسم أولاً';
                    }
                    return null;
                  },
                  submit: (String value){
                    if(nameKey.currentState!.validate()) {
                      FocusScope.of(context).requestFocus(initExpensesNode);
                    }
                  }
                ),
                createTextField(
                  title: 'يملك الآن:',
                  hint: 'أدخل المبلغ',
                  controller: initExpensesController,
                  formKey: initExpensesKey,
                  node: initExpensesNode,
                  inputType: TextInputType.number,
                  formatter: DecimalFormatter(),
                  prefixIcon: Icons.currency_pound,
                    validator: (String value){
                      if(value.isEmpty) {
                        return 'يجب إدخال المبلغ';
                      }
                      if(!DecimalFormatter().patternFormatter().hasMatch(value)){
                        return 'أدخل الرقم أولاً';
                      }
                      return null;
                    }
                ),
                createButton(
                  text: 'إضافة',
                  onPressed: () {
                    if(nameKey.currentState!.validate() && initExpensesKey.currentState!.validate()) {
                      double value = double.parse(initExpensesController.text);
                      cubit.addChild(nameController.text, value);
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icons.add,
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierLabel: 'add child alert',
    barrierDismissible: true
  );
}