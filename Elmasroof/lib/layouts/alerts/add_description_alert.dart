import 'dart:ui';

import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';

typedef OnUpdateDescription = void Function(int id, String description);

TextEditingController descriptionController = TextEditingController();
GlobalKey<FormFieldState> descriptionKey = GlobalKey();
FocusNode descriptionNode = FocusNode();

void showAddDescriptionAlert({
  required BuildContext context,
  required OnUpdateDescription onUpdateDescription,
  required ChildExpensesChangingModel child,
  String description = '',
}){
  descriptionController.text = description;
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation){
        return _createDialog(context, onUpdateDescription, child);
      },
      barrierLabel: 'add child alert',
      barrierDismissible: true
  );
}

Widget _createDialog(BuildContext context, OnUpdateDescription onUpdateDescription,
    ChildExpensesChangingModel child,) => Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, onUpdateDescription, child),
    ),
  ),
);

Widget _createBody(BuildContext context, OnUpdateDescription onUpdateDescription,
    ChildExpensesChangingModel child,) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    _createDescriptionTextField(),
    const SizedBox(height: 8,),
    _createAddDescription(context, onUpdateDescription, child),
  ],
);

Widget _createDescriptionTextField() => createTextField(
  title: 'تفاصيل العملية',
  hint: 'التفاصيل',
  height: 100,
  expand: true,
  alignment: TextAlign.center,
  controller: descriptionController,
  formKey: descriptionKey,
  node: descriptionNode,
  validator: (String value){
    if(value.isEmpty) {
      return 'أدخل تفاصيل العملية أولاً';
    }
    return null;
  },
);

Widget _createAddDescription(BuildContext context, OnUpdateDescription onUpdateDescription,
    ChildExpensesChangingModel child) => createButton(
  text: 'أضف تفاصيل العملية',
  onPressed: () {
    if(descriptionKey.currentState!.validate()) {
      child.description = descriptionController.text;
      onUpdateDescription(child.id!, child.description);
      Navigator.of(context).pop();
    }
  },
);
