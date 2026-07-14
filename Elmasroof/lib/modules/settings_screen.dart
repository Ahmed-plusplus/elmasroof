import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/modules/about_screen.dart';
import 'package:elmasroof/modules/forget_password_screen.dart';
import 'package:elmasroof/modules/rewards_screen.dart';
import 'package:elmasroof/shared/biometric_availability.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<Widget> items = [];
  final ValueNotifier<String> _versionNotifier = ValueNotifier('');
  late AuthCubit _authCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PackageInfo.fromPlatform().then(
        (packageInfo){
          _versionNotifier.value = packageInfo.version;
        }
    ).catchError((e) {
      print(e.toString());
    });

    _authCubit = AuthCubit.get(context);

    items = [
      _changeRewardsValue(),
      _changePassword(),
      if(BiometricAvailability.instance.isSupported)
        _activateBiometerAuth(),
      _linkAppWithGmail(),
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
            ValueListenableBuilder(
              valueListenable: _versionNotifier,
              builder: (context, value, child) {
                return Text('Version $value');
              }
            ),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  Widget _changeRewardsValue() => createButton(
    text: 'تعديل قيم الجوائز',
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) =>
              RewardsScreen(callback: (context) => Navigator.of(context).pop())
      ),
    ),
  );

  Widget _changePassword()  => createButton(
    text: 'تغيير كلمة المرور',
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => ForgetPasswordScreen()
      ),
    ),
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
