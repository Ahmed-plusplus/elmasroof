import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class InterstitialAdScreen {

  InterstitialAd? _interstitialAd;
  final String adUnitId = Platform.isAndroid
  // Use this ad unit on Android...
      ? dotenv.get('ANDROID_INTERSTITIAL_AD_UNIT_ID')
  // ... or this one on iOS.
      : dotenv.get('IOS_INTERSTITIAL_AD_UNIT_ID');

  InterstitialAdScreen(){
    _loadInterstitialAd();
  }

  final List<Function> _func = [];

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _func[0]();
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, err){
              ad.dispose();
            }
          );
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void start([Function? function]){
    FocusManager.instance.primaryFocus?.unfocus();
    if (_interstitialAd != null) {
      _func.clear();
      function == null ? null :_func.add(function);
      _interstitialAd!.show();
      _interstitialAd = null; // prevent reusing
      _loadInterstitialAd();  // load another for next time
    } else {
      print("Ad not loaded yet!");
      _loadInterstitialAd();
    }
  }

  void dispose() => _interstitialAd?.dispose();
}
