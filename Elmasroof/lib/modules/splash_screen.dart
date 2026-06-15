import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/modules/create_password_screen.dart';
import 'package:elmasroof/modules/enter_password_screen.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSupported = false;
  List<BiometricType> _availableBiometric = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalAuthentication auth = LocalAuthentication();

    Future.delayed(
        const Duration(seconds: 5),
        () => Future.wait([
              auth.isDeviceSupported(),
              auth.getAvailableBiometrics(),
              handleIncrementalExpenses(),
            ]).then((list) {
              _isSupported = list[0] as bool;
              _availableBiometric = list[1] as List<BiometricType>;
              print('is supported: $_isSupported');
              print('available: $_availableBiometric');
              _navigateScreen();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/jsons/fake_3d_vector_coin.json'),
          const SizedBox(height: 20,),
          const Text('Elmasroof', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          const Text('Manage your children\'s expenses', style: TextStyle(fontSize: 20, color: Colors.grey),)
        ],
      ),
    );
  }

  void _navigateScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) =>
          (SharedManager.getData(key: SharedManager.LOGIN_PASSWORD) == null)
              ? CreatePasswordScreen(
                  isSupported: _isSupported,
                  availableBiometric: _availableBiometric)
              : EnterPasswordScreen(
                  isSupported: _isSupported,
                  availableBiometric: _availableBiometric),
    ));
  }

  Future<void> handleIncrementalExpenses() async{
    var currentDate = DateTime.now();
    var lastDateAsString = SharedManager.getData(key: SharedManager.LAST_DATE) as String?;
    if(lastDateAsString == null) {
      lastDateAsString = currentDate.toIso8601String();
      SharedManager.putData(
          key: SharedManager.LAST_DATE, value: lastDateAsString);
    }
    var lastDate = DateTime.parse(lastDateAsString);
    if(lastDate.day != currentDate.day || lastDate.month != currentDate.month || lastDate.year != currentDate.year) {
      int numberOfDays = currentDate.difference(lastDate).inDays;
      await increaseExpenses(days: numberOfDays);
      SharedManager.putData(
          key: SharedManager.LAST_DATE, value: currentDate.toIso8601String());
    }
    var nextDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
    var delay = nextDate.difference(currentDate);
    startNewDay(delay);
  }

  Future<void> increaseExpenses({int days = 1}) async {
    DateTime today = DateTime.now();
    HiveStorage hiveStorage = HiveStorage();
    SqfliteDB db = SqfliteDB();
    var list = hiveStorage.getKeys();
    for(var el in list){
      var child = hiveStorage.get(el);
      for(var curr in Currency.values) {
        child!.expenses[curr] = (child.expenses[curr] ?? 0) + (child.increment[curr] ?? 0) * days;
        /// if(today <= punishUntil) decrease for all days
        /// else if(today - days < punishUntil) decrease (punishUntil - today + days) days
        if(child.punishmentUntil != null){
          /// print(today.compareTo(future)); // -1
          /// print(today.compareTo(past)); // 1
          /// print(today.compareTo(newDate)); // 0
          if(today.compareTo(child.punishmentUntil!) < 1){
            child.expenses[curr] = (child.expenses[curr] ?? 0) - (child.increment[curr] ?? 0) * days;
          } else if(today.subtract(Duration(days: days)).compareTo(child.punishmentUntil!) == -1){
            child.expenses[curr] = (child.expenses[curr] ?? 0)
                - (child.increment[curr] ?? 0) * (child.punishmentUntil!.difference(today).inDays + days);
            if((child.increment[curr] ?? 0) > 0) {
              await storeIncrements(db, child, curr, child.punishmentUntil!.difference(today).inDays + days);
            }
          } else {
            child.punishmentUntil = null;
            if((child.increment[curr] ?? 0) > 0) {
              await storeIncrements(db, child, curr, days);
            }
          }
        } else {
          if((child.increment[curr] ?? 0) > 0) {
            await storeIncrements(db, child, curr, days);
          }
        }
      }
      hiveStorage.put(el, child!);
    }
    ListenOnValue.expensesNotifier.value++;
  }

  Future<void> storeIncrements(SqfliteDB db, ChildModel child, Currency curr, int days) async{
    DateTime today = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    for (int i = days; i > 0; i--) {
      await db.insertChildData(
          ChildExpensesChangingModel(
              name: child.name,
              expenses: (curr, child.increment[curr]!),
              total: (curr, child.expenses[curr]! - (child.increment[curr]! * i)),
              dateTime: today.subtract(Duration(days: i - 1)),
              description: 'زيادة يومية'
          )
      );
    }
  }

  void startNewDay(Duration delay) {
    Future.delayed(delay, () {
      increaseExpenses();
      startNewDay(Duration(days: 1));
    });
  }

}
