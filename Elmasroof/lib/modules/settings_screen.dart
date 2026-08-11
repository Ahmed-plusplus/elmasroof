import 'dart:convert';

import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/layouts/ads/interstitial_ad_screen.dart';
import 'package:elmasroof/layouts/alerts/failed_dialog.dart';
import 'package:elmasroof/layouts/alerts/merge_with_firebase_alert.dart';
import 'package:elmasroof/layouts/alerts/select_children_alert.dart';
import 'package:elmasroof/layouts/alerts/success_dialog.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/models/user_model.dart';
import 'package:elmasroof/modules/about_screen.dart';
import 'package:elmasroof/modules/forget_password_screen.dart';
import 'package:elmasroof/modules/qr_scanner_screen.dart';
import 'package:elmasroof/modules/rewards_screen.dart';
import 'package:elmasroof/shared/biometric_availability.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/app_device_info.dart';
import 'package:elmasroof/shared/enums/auth_type.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/remote/firebase/firebase_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<Widget> items = [];
  late AuthCubit _authCubit;
  final ValueNotifier<bool> _isBiometricEnabled =
    ValueNotifier(SharedManager.getData(key: SharedManager.LOGIN_BIOMETRIC) ?? false);
  ValueNotifier<String> clientId =
    ValueNotifier(SharedManager.getData(key: SharedManager.USER_ID) ?? '');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  InterstitialAdScreen interstitialAdScreen = InterstitialAdScreen();
  final HiveStorage _hiveStorage = HiveStorage();

  @override
  void initState() {
    super.initState();

    _authCubit = AuthCubit.get(context);

    items = [
      _changeRewardsValue(),
      _changePassword(),
      if(BiometricAvailability.instance.isSupported)
        _activateBiometerAuth(),
      _linkApp(),
      _aboutApp()
    ];
  }

  @override
  void dispose() {
    interstitialAdScreen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: items[index],
                ),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Container(height: 1, color: Colors.grey,),
                ),
              ),
            ),
            if(clientId.value.isNotEmpty)
              Expanded(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: PrettyQrView.data(
                    data: jsonEncode({
                      'type': 'link_parent_qr',
                      'app': 'Elmasroof',
                      'data': clientId.value,
                    }),
                    decoration: PrettyQrDecoration(
                      shape: const PrettyQrSmoothSymbol(
                        color: Colors.lightBlue,
                      ),
                      image: PrettyQrDecorationImage(
                        image: SvgImageProvider(
                          ConstAssetImages.expenses.path,
                        ),
                      ),
                      background: Colors.transparent,
                      quietZone: PrettyQrQuietZone.zero,
                    ),
                    errorCorrectLevel: QrErrorCorrectLevel.H
                  ),
                ),
              ),
            Text('Version ${AppDeviceInfo.versionName}'),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  Widget _changeRewardsValue() => GestureDetector(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) =>
              RewardsScreen(callback: (context) => Navigator.of(context).pop())
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.workspace_premium_outlined, color: Colors.grey,),
        SizedBox(width: 8,),
        Text('تعديل قيم الجوائز', style: TextStyle(fontSize: 28),),
      ],
    ),
  );

  Widget _changePassword()  => GestureDetector(
    onTap: () async {
      if(SharedManager.getData(key: SharedManager.LOGIN_BIOMETRIC) ?? false) {
        if(await _authCubit.authenticateWithBiometrics()){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => ForgetPasswordScreen()
            ),
          );
        }
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => ForgetPasswordScreen()
          ),
        );
      }
    },
    child: Row(
      children: [
        Icon(Icons.vpn_key, color: Colors.grey,),
        SizedBox(width: 8,),
        Text('تغيير كلمة المرور', style: TextStyle(fontSize: 28),),
      ],
    ),
  );

  Widget _activateBiometerAuth() => Row(
    children: [
      Icon(Icons.fingerprint, color: Colors.grey,),
      SizedBox(width: 8,),
      Text('تفعيل البصمة', style: TextStyle(fontSize: 26),),
      Spacer(),
      ValueListenableBuilder(
        valueListenable: _isBiometricEnabled,
        builder: (context, value, child) {
          return Switch(
            value: value,
            activeTrackColor: Colors.lightBlue,
            onChanged: (val) async {
              print(val);
              if(val){
                if(await _authCubit.authenticateWithBiometrics()){
                  SharedManager.putData(key: SharedManager.LOGIN_BIOMETRIC, value: true);
                  _isBiometricEnabled.value = true;
                }
              } else {
                SharedManager.putData(key: SharedManager.LOGIN_BIOMETRIC, value: false);
                _isBiometricEnabled.value = false;
              }
            }
          );
        }
      ),
      Spacer(),
      Spacer(),
      Spacer(),
      Spacer(),
    ],
  );

  Widget _aboutApp() => GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutScreen())),
    child: Row(
      children: [
        Icon(Icons.info, color: Colors.grey,),
        SizedBox(width: 8,),
        Text('عن التطبيق', style: TextStyle(fontSize: 28),),
      ],
    ),
  );

  Widget _linkAppWithGmail() => GestureDetector(
    onTap: () => loginWithGoogle(),
    child: Row(
      children: [
        Icon(Icons.link, color: Colors.grey,),
        SizedBox(width: 8,),
        Text('ربط التطبيق بحساب جوجل', style: TextStyle(fontSize: 28),),
      ],
    ),
  );

  void loginWithGoogle() async {
    UserCredential? userCredential = await signInWithGoogle();
    if (userCredential != null) {

      if(userCredential.additionalUserInfo?.isNewUser ?? false) {
        // First time sign-in
        showSuccessDialog(context: context, message: 'تم التسجيل بنجاح');
        _setClientIdValue(userCredential.user?.uid ?? '');
        // Sync local storage with Firebase
        FirebaseHandler.instance.addNewUser(
          UserModel(
            uid: userCredential.user?.uid ?? '',
            parentType: SharedManager.getData(key: SharedManager.PARENT_TYPE) ?? 0,
            lastUpdate: DateTime.now(),
            children: _hiveStorage.getAll() ?? [],
          ),
        );
      } else {
        // Subsequent sign-in
        showMergeWithFirebaseAlert(
          context: context,
          onPreviousChoose: () {
            /*get all data from firebase then clear and write it to local storage*/
            _hiveStorage.removeAll()
                .then((value) {
                  FirebaseHandler.instance.getUser(userCredential.user?.uid ?? '')
                      .then((userModel) {
                    if (userModel != null) {
                      userModel.children.forEach((child) => _hiveStorage.put(child.name, child));
                      showSuccessDialog(context: context, message: 'تم استرداد البيانات السابقة');
                    } else {
                      showFailedDialog(context: context, message: 'لم يتم العثور على بيانات سابقة');
                    }
                  }).catchError((e) => print('Error fetching data from Firebase: $e'));
            })
                .catchError((e) => print('Error clearing local storage: $e'));

          },
          onCurrentChoose: () {
            /*clear firebase data then sync local storage with firebase*/
            FirebaseHandler.instance.removeAllData(userCredential.user?.uid ?? '')
            .then((value) {
              FirebaseHandler.instance.addNewUser(
                UserModel(
                  uid: userCredential.user?.uid ?? '',
                  parentType: SharedManager.getData(key: SharedManager.PARENT_TYPE) ?? 0,
                  lastUpdate: DateTime.now(),
                  children: _hiveStorage.getAll() ?? [],
                ),
              ).then((value) {
                print('Data synced with Firebase');
              }).catchError((e) => print('Error syncing data with Firebase: $e'));
            })
            .catchError((e) => print('Error removing data from Firebase: $e'));
          },
          adScreen: interstitialAdScreen,
        );
        _setClientIdValue(userCredential.user?.uid ?? '');
      }
    } else {
      showFailedDialog(context: context, message: 'لم يتم تسجيل الدخول');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await _googleSignIn.initialize();

      // Show Google account selection
      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      // Get authentication information
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await _firebaseAuth.signInWithCredential(credential);

    } on GoogleSignInException catch (e) {
      print('Google Sign-In error: $e');
      return null;
    } catch (e) {
      print('Firebase authentication error: $e');
      return null;
    }
  }

  Widget _linkApp() => ValueListenableBuilder(
    valueListenable: clientId,
    builder: (context, value, child){
      return value.isEmpty ? _linkAppWithGmail() : _linkAppWithOtherParent();
    },
  );

  Widget _linkAppWithOtherParent() => GestureDetector(
    onTap: () => handleLinkParents(),
    child: Row(
      children: [
        Icon(Icons.link, color: Colors.grey,),
        SizedBox(width: 8,),
        Text('ربط الأطفال بحساب ${SharedManager.getData(key: SharedManager.PARENT_TYPE) == 1 ? "الأب" : "الأم"}', style: TextStyle(fontSize: 28),),
      ],
    ),
  );

  void _setClientIdValue(String uid) {
    clientId.value = uid;
    SharedManager.putData(key: SharedManager.USER_ID, value: uid);
    print('clientId: $uid');
  }

  Future<void> handleLinkParents() async{
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const QRScannerScreen(),
      ),
    );

    if (result != null) {
      print('Scanned data: $result');
      if(result == 'Invalid QR for app') {
        showFailedDialog(context: context, message: 'هذا الرمز غير صالح مع التطبيق');
      } else if(result == 'Invalid QR format') {
        showFailedDialog(context: context, message: 'الرمز غير صالح');
      } else if(result == 'No QR detected') {
        showFailedDialog(context: context, message: 'لم يتم مسح أي رمز');
      } else if(result == clientId.value) {
        showFailedDialog(context: context, message: 'لا يمكن ربط الحساب بنفسه');
      } else {
        // Link the children to the other parent's account
        FirebaseHandler.instance.getUser(result)
            .then((otherParent) {
          if (otherParent != null) {
            if(otherParent.parentType == SharedManager.getData(key: SharedManager.PARENT_TYPE)) {
              showFailedDialog(context: context, message: 'لا يمكن ربط الأطفال بحساب من نفس النوع (أب/أم)');
              return;
            }
            // create alert to confirm linking the children to the other parent's account
            showSelectChildrenAlert(
              context: context,
              yourChildren: _hiveStorage.getAll()?.where((child) => child.otherParentId == null).toList() ?? [],
              otherChildren: otherParent.children.where((child) => child.otherParentId == null).toList(),
              otherParentId: result,
              adScreen: InterstitialAdScreen(),
              onDismiss: () =>
                showSuccessDialog(
                    context: context,
                    message: 'تم ربط الأطفال بحساب ${SharedManager.getData(key: SharedManager.PARENT_TYPE) == 1 ? "الأب" : "الأم"}'
                )
            );
          } else {
            showFailedDialog(context: context, message: 'لم يتم العثور على بيانات الحساب الآخر');
          }
        }).catchError((e) => print('Error fetching data from Firebase: $e'));
      }
    }
  }
}
