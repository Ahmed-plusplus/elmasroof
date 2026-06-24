import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/models/reward_data_model.dart';
import 'package:elmasroof/modules/create_password_screen.dart';
import 'package:elmasroof/modules/enter_password_screen.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/enum/reward.dart';
import 'package:elmasroof/shared/enum/transaction_type.dart';
import 'package:elmasroof/shared/extensions/date_time_extension.dart';
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
              _handleIncrementalExpenses(),
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

  Future<void> _handleIncrementalExpenses() async{
    var currentDate = DateTime.now().dateOnly();
    var lastDateAsString = SharedManager.getData(key: SharedManager.LAST_DATE) as String?;
    if(lastDateAsString == null) {
      lastDateAsString = currentDate.toIso8601String();
      SharedManager.putData(
          key: SharedManager.LAST_DATE, value: lastDateAsString);
    }
    var lastDate = DateTime.parse(lastDateAsString);
    if(!lastDate.isAtSameMomentAs(currentDate)) {
      int numberOfDays = currentDate.difference(lastDate).inDays;
      await _increaseExpenses(today: currentDate,days: numberOfDays);
      SharedManager.putData(
          key: SharedManager.LAST_DATE, value: currentDate.toIso8601String());
    }
    var nextDate = currentDate.add(Duration(days: 1));
    var delay = nextDate.difference(DateTime.now());
    _startNewDay(delay);
  }

  Future<void> _increaseExpenses({required DateTime today, int days = 1}) async {
    HiveStorage hiveStorage = HiveStorage();
    SqfliteDB db = SqfliteDB();
    var list = hiveStorage.getKeys();
    for(var el in list){
      var child = hiveStorage.get(el);
      for(var curr in Currency.values) {
        await _handleIncrement(child!, curr, days, today, db);
      }
      hiveStorage.put(el, child!);
    }
    ListenOnValue.expensesNotifier.value++;
  }

  void _setReward1(ChildModel child, Currency curr, double trans) {
    if(trans < 0){
      double percentage = (-trans) / (child.increment[curr]! * 30);
      if(percentage >= 0.1){
        _setReward(child, Reward.goodBeginning);
      }
      if(percentage >= 0.25){
        _setReward(child, Reward.strong);
      }
      if(percentage >= (1.0/3)){
        _setReward(child, Reward.star);
      }
      if(percentage >= 0.5){
        _setReward(child, Reward.shiny);
      }
      //TODO:: if the increasing >= decreasing then give the best reward of saving
    } else {
      _setReward(child, Reward.goodBeginning);
      _setReward(child, Reward.strong);
      _setReward(child, Reward.star);
      _setReward(child, Reward.shiny);
    }
  }

  void _setReward2(ChildModel child, Currency curr, double increaseTrans) {
    double percentage = increaseTrans / (child.increment[curr]! * 30);
    if(percentage >= 0.5){
      _setReward(child, Reward.dreamer);
    }
    if(percentage >= 0.8){
      _setReward(child, Reward.ambitious);
    }
    if(percentage >= 1){
      _setReward(child, Reward.hero);
    }
    if(percentage >= 2){
      _setReward(child, Reward.legend);
    }
  }

  void _setReward3(ChildModel child, Currency curr) {
    if((child.expenses[curr] ?? 0) >= 100){
      _setReward(child, Reward.bronze);
    }
    if((child.expenses[curr] ?? 0) >= 1000){
      _setReward(child, Reward.silver);
    }
    if((child.expenses[curr] ?? 0) >= 10000){
      _setReward(child, Reward.golden);
    }
    if((child.expenses[curr] ?? 0) >= 100000){
      _setReward(child, Reward.diamond);
    }
    if((child.expenses[curr] ?? 0) >= 1000000){
      _setReward(child, Reward.master);
    }
  }

  void _setReward(ChildModel child, Reward reward){
    if(child.rewards[reward] == null){
      child.rewards[reward] = RewardDataModel(0, true, false);
    } else {
      child.rewards[reward]!.isTaken = true;
    }
  }

  Future<void> _storeIncrements(SqfliteDB db, ChildModel child, Currency curr, DateTime today, int days) async{
    for (int i = days - 1; i >= 0; i--) {
      await db.insertChildData(
        ChildExpensesChangingModel(
            name: child.name,
            expenses: (curr, child.increment[curr]!),
            total: (curr, child.expenses[curr]! - (child.increment[curr]! * i)),
            dateTime: today.subtract(Duration(days: i)),
            description: 'زيادة يومية'
        ),
        TransactionType.dailyTransaction
      );
    }
  }

  void _startNewDay(Duration delay) {
    Future.delayed(delay, () async{
      await _increaseExpenses(today: DateTime.now().dateOnly());
      _startNewDay(Duration(days: 1));
    });
  }

  Future<void> _handleIncrement(ChildModel child, Currency curr, int days, DateTime today, SqfliteDB db) async {
    child.expenses[curr] = (child.expenses[curr] ?? 0) + (child.increment[curr] ?? 0) * days;
    if(child.punishmentUntil != null){
      /// if(today <= punishUntil) decrease for all days
      if(today.compareTo(child.punishmentUntil!) < 1){
        child.expenses[curr] = (child.expenses[curr] ?? 0) - (child.increment[curr] ?? 0) * days;
        /// else if(today - days < punishUntil) decrease (punishUntil - today + days) days
      } else {
        child.expenses[curr] = (child.expenses[curr] ?? 0)
            - (child.increment[curr] ?? 0) * (child.punishmentUntil!.difference(today).inDays + days); // subtract from punish days
        if((child.increment[curr] ?? 0) > 0) {
          await _storeIncrements(db, child, curr, today, today.difference(child.punishmentUntil!).inDays); // number of days after punish
        }
        child.punishmentUntil = null;
      }
    } else {
      if((child.increment[curr] ?? 0) > 0) {
        await _storeIncrements(db, child, curr, today, days);
      }
    }
    if((child.increment[curr] ?? 0) > 0) {
      double trans = await db.getCustomTransactionValue(child.name, today.subtract(Duration(days: 30)), curr, false);
      _setReward1(child, curr, trans);
      double increaseTrans = await db.getCustomTransactionValue(child.name, today.subtract(Duration(days: 30)), curr, true);
      _setReward2(child, curr, increaseTrans);
    }
    _setReward3(child, curr);
  }

}
