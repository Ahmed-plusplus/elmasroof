import 'package:elmasroof/modules/forget_password_screen.dart';
import 'package:elmasroof/modules/rewards_screen.dart';
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
  ValueNotifier<String> _versionNotifier = ValueNotifier('');

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

    items = [
      _changeRewardsValue(),
      _changePassword(),
      _activateBiometerAuth(),
      _aboutApp()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              itemBuilder: (context, index) => items[index],
              separatorBuilder: (context, index) => Container(height: 1, color: Colors.grey,),
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

  Widget _aboutApp() => Container(child: Text('عن التطبيق'),);
}
