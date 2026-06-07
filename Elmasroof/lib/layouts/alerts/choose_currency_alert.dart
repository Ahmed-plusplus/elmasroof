import 'dart:ui';

import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnChooseCurrency = void Function(Currency currency);

void showChooseCurrencyAlert({
  required BuildContext context,
  required OnChooseCurrency onChoose,
}){
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
              child: GridView.count(crossAxisCount: 3, shrinkWrap: true,
                children: Currency.values.map( (currency) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      onChoose(currency);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.lightBlue),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(currency.icon, fit: BoxFit.contain, width: 40.0, height: 40.0,),
                    ),
                  ),
                ),).toList()
              ),
            ),
          ),
        );
      },
      barrierLabel: 'change currency alert',
      barrierDismissible: true
  );
}