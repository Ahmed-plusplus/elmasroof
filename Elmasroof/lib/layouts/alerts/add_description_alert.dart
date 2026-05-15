import 'dart:ui';

import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';

void showAddDescriptionAlert({
  required BuildContext context,
  required HistoryCubit cubit,
  required ChildModel child,
}){
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormFieldState> descriptionKey = GlobalKey();
  FocusNode descriptionNode = FocusNode();
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
                      title: 'تفاصيل العملية',
                      hint: 'التفاصيل',
                      height: 250,
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
                  ),
                  const SizedBox(height: 8,),
                  createButton(
                    text: 'أضف تفاصيل العملية',
                    onPressed: () {
                      if(descriptionKey.currentState!.validate()) {
                        child.description = descriptionController.text;
                        cubit.updateDescriptionOfTransaction(child.id!, child.description);
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
      barrierLabel: 'add child alert',
      barrierDismissible: true
  );
}