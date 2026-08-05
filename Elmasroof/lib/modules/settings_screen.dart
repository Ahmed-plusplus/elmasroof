import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/layouts/alerts/success_dialog.dart';
import 'package:elmasroof/modules/about_screen.dart';
import 'package:elmasroof/modules/forget_password_screen.dart';
import 'package:elmasroof/modules/rewards_screen.dart';
import 'package:elmasroof/shared/biometric_availability.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/app_device_info.dart';
import 'package:elmasroof/shared/enums/auth_type.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
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
    ValueNotifier(SharedManager.getData(key: SharedManager.CLIENT_ID) ?? '');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  void initState() {
    // TODO: implement initState
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: items[index],
              ),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(height: 1, color: Colors.grey,),
              ),
              shrinkWrap: true,
            ),
            if(clientId.value.isNotEmpty)
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: PrettyQrView.data(
                      data: AppDeviceInfo.id,
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
        showSuccessDialog(context: context, message: 'تم تسجيل الدخول بنجاح');
        _setClientIdValue(userCredential.user?.uid ?? '');
      } else {
        // Subsequent sign-in
        showSuccessDialog(context: context, message: 'تم تسجيل الدخول مسبقًا');
        _setClientIdValue(userCredential.user?.uid ?? '');
      }
    } else {
      showSuccessDialog(context: context, message: 'فشل تسجيل الدخول');
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
    onTap: () => null,
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
    SharedManager.putData(key: SharedManager.CLIENT_ID, value: uid);
    print('clientId: $uid');
  }
}
