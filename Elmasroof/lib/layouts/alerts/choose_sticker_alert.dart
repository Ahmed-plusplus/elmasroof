import 'dart:ui';

import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnChooseSticker = void Function(int index);

void showChooseStickerAlert({
  required BuildContext context,
  required OnChooseSticker onChoose,
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
              child: GridView.count(crossAxisCount: 4, shrinkWrap: true,
                children: List.generate(ConstAssetImages.faces.length, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      onChoose(index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.lightBlue),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(ConstAssetImages.faces[index].path, fit: BoxFit.contain, width: 40.0, height: 40.0,),
                    ),
                  ),
                ),),
              ),
            ),
          ),
        );
      },
      barrierLabel: 'change sticker alert',
      barrierDismissible: true
  );
}