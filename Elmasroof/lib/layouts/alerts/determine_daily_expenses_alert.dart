import 'dart:ui';

import 'package:elmasroof/cubit/daily_expenses_cubit/daily_expenses_cubit.dart';
import 'package:elmasroof/cubit/daily_expenses_cubit/daily_expenses_state.dart';
import 'package:elmasroof/layouts/alerts/choose_currency_alert.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextEditingController expensesController = TextEditingController();
GlobalKey<FormFieldState> expensesKey = GlobalKey();
FocusNode expensesNode = FocusNode();

void showDetermineDailyExpensesAlert({
  required BuildContext context,
  required ChildModel child,
}){
  DailyExpensesCubit cubit = DailyExpensesCubit.get(context);
  expensesController.text = '${child.increment[cubit.currency] ?? 0}';
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation){
        return _createDialog(context, child, cubit);
      },
      barrierLabel: 'determine daily expenses alert',
      barrierDismissible: true
  );
}

Widget _createDialog(BuildContext context, ChildModel child, DailyExpensesCubit cubit)
=> Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createBody(context, child, cubit),
    ),
  ),
);

Widget _createBody(BuildContext context, ChildModel child, DailyExpensesCubit cubit)
=> Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    _createExpensesTextField(cubit),
    const SizedBox(height: 8,),
    createButton(
      text: 'انشاء مبلغ الزيادة',
      onPressed: () {
        if(expensesKey.currentState!.validate()) {
          child.increment[cubit.currency] = double.parse(expensesController.text);
          HiveStorage hiveStorage = HiveStorage();
          hiveStorage.put(child.name, child);
          Navigator.of(context).pop();
        }
      },
    ),
  ],
);

Widget _createExpensesTextField(DailyExpensesCubit cubit) => createTextField(
    title: 'الزيادة اليومية',
    hint: 'أدخل المبلغ',
    controller: expensesController,
    formKey: expensesKey,
    node: expensesNode,
    inputType: TextInputType.number,
    formatter: PositiveFormatter(),
    prefixWidget: _createPrefixWidget(cubit),
    validator: (String value){
      if(value.isEmpty) {
        return 'يجب إدخال المبلغ';
      }
      if(!PositiveFormatter().patternFormatter().hasMatch(value)){
        return 'أدخل الرقم أولاً';
      }
      return null;
    }
);

Widget _createPrefixWidget(DailyExpensesCubit cubit) => BlocConsumer<DailyExpensesCubit, DailyExpensesState>(
    listener: (context, state) {},
    builder: (context, state) {
      cubit = DailyExpensesCubit.get(context);
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: SvgPicture.asset(cubit.currency.icon),
          ),
        ),
        onTap: () => showChooseCurrencyAlert(
          context: context,
          onChoose: (currency) => cubit.changeCurrency(currency),
        ),
      );
    }
);