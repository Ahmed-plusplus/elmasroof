import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/modules/about_screen.dart';
import 'package:elmasroof/modules/forget_password_screen.dart';
import 'package:elmasroof/modules/rewards_screen.dart';
import 'package:elmasroof/shared/biometric_availability.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/app_device_info.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
      // _linkAppWithGmail(),
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
            // Expanded(
            //   child: Center(
            //     child: SizedBox(
            //       width: 150,
            //       height: 150,
            //       child: PrettyQrView.data(
            //         data: AppDeviceInfo.id,
            //         decoration: PrettyQrDecoration(
            //           shape: const PrettyQrSmoothSymbol(
            //             color: Colors.lightBlue,
            //           ),
            //           image: PrettyQrDecorationImage(
            //             image: SvgImageProvider(
            //               ConstAssetImages.expenses.path,
            //             ),
            //           ),
            //           background: Colors.transparent,
            //           quietZone: PrettyQrQuietZone.zero,
            //         ),
            //         errorCorrectLevel: QrErrorCorrectLevel.H
            //       ),
            //     ),
            //   ),
            // ),
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
    child: Row(children: [ Text('تعديل قيم الجوائز', style: TextStyle(fontSize: 28),), ],),
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
    child: Row(children: [ Text('تغيير كلمة المرور', style: TextStyle(fontSize: 28),), ],),
  );

  Widget _activateBiometerAuth() => Container(child: Text('تفعيل البصمة'),);

  Widget _aboutApp() => GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutScreen())),
    child: Row(children: [ Text('عن التطبيق', style: TextStyle(fontSize: 28),), ],),
  );

  Widget _linkAppWithGmail() => GestureDetector(
    child: Row(
      children: [
        Text('ربط التطبيق بحساب جوجل', style: TextStyle(fontSize: 28),),
      ],
    ),
  );
}
