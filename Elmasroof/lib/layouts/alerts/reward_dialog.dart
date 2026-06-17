import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:elmasroof/shared/constants/const_asset_sounds.dart';
import 'package:elmasroof/shared/enum/reward.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

StreamSubscription? _stream;

void showRewardDialog({
  required BuildContext context,
  required String name,
  required Reward reward,
  VoidCallback? onDismiss,
}){
  if(FocusScope.of(context).hasFocus){
    FocusScope.of(context).unfocus();
  }
  AudioPlayer audioPlayer = AudioPlayer();
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation){
      _stream = audioPlayer.onPlayerComplete.listen((event) {
        if(context.mounted){
          Navigator.of(context, rootNavigator: true).pop(true);
          if(onDismiss != null) {
            onDismiss();
            _stream?.cancel();
          }
        }
      });
      return _createDialog(context, name, reward);
    },
    barrierLabel: 'reward dialog',
    barrierDismissible: false,
  );
  audioPlayer.setVolume(0.2).then((volume) => audioPlayer.play(AssetSource(ConstAssetSounds.applause.path)));
}

Widget _createDialog(BuildContext context, String name, Reward reward) => Dialog(
  backgroundColor: Colors.white,
  surfaceTintColor: Colors.white,
  alignment: Alignment.center,
  insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(reward.iconPath, fit: BoxFit.contain, width: 80.0, height: 80.0,),
          const SizedBox(height: 16.0,),
          Text(reward.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          Text('$name ${reward.description}', style: TextStyle(fontSize: 14.0, ), textAlign: TextAlign.center,),
        ],
      ),
    ),
  ),
);