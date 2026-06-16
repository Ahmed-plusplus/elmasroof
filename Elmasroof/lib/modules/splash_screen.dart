import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
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
      await increaseExpenses(today: currentDate,days: numberOfDays);
      SharedManager.putData(
          key: SharedManager.LAST_DATE, value: currentDate.toIso8601String());
    }
    var nextDate = currentDate.add(Duration(days: 1));
    var delay = nextDate.difference(DateTime.now());
    startNewDay(delay);
  }

  Future<void> increaseExpenses({required DateTime today, int days = 1}) async {
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
          } else {
            child.expenses[curr] = (child.expenses[curr] ?? 0)
                - (child.increment[curr] ?? 0) * (child.punishmentUntil!.difference(today).inDays + days); // subtract from punish days
            if((child.increment[curr] ?? 0) > 0) {
              await storeIncrements(db, child, curr, today, today.difference(child.punishmentUntil!).inDays); // number of days after punish
            }
            child.punishmentUntil = null;
          }
        } else {
          if((child.increment[curr] ?? 0) > 0) {
            await storeIncrements(db, child, curr, today, days);
          }
        }
        //TODO:: if no daily increment skip all of following
        if((child.increment[curr] ?? 0) > 0) {
          double trans = await db.getCustomTransactionValue(child.name, today.subtract(Duration(days: 30)), curr, false);
          //TODO:: else calculate the percentage of ( (decreasing - increasing) / (daily adding * 30) )
          if(trans < 0){
            double percentage = (-trans) / (child.increment[curr]! * 30);
            if(percentage >= 0.1){
              setReward(child, Reward.goodBeginning);
            }
            if(percentage >= 0.25){
              setReward(child, Reward.strong);
            }
            if(percentage >= (1.0/3)){
              setReward(child, Reward.star);
            }
            if(percentage >= 0.5){
              setReward(child, Reward.shiny);
            }
          //TODO:: if the increasing >= decreasing then give the best reward of saving
          } else {
            setReward(child, Reward.goodBeginning);
            setReward(child, Reward.strong);
            setReward(child, Reward.star);
            setReward(child, Reward.shiny);
          }
          //TODO:: calculate the percentage of ( (increasing) / (daily adding * 30) )
          double increaseTrans = await db.getCustomTransactionValue(child.name, today.subtract(Duration(days: 30)), curr, true);
          double percentage = increaseTrans / (child.increment[curr]! * 30);
          if(percentage >= 0.5){
            setReward(child, Reward.dreamer);
          } else if(percentage >= 0.8){
            setReward(child, Reward.ambitious);
          } else if(percentage >= 1){
            setReward(child, Reward.hero);
          } else if(percentage >= 2){
            setReward(child, Reward.legend);
          }
        }

        if((child.expenses[curr] ?? 0) >= 100){
          setReward(child, Reward.bronze);
        }
        if((child.expenses[curr] ?? 0) >= 1000){
          setReward(child, Reward.silver);
        }
        if((child.expenses[curr] ?? 0) >= 10000){
          setReward(child, Reward.golden);
        }
        if((child.expenses[curr] ?? 0) >= 100000){
          setReward(child, Reward.diamond);
        }
        if((child.expenses[curr] ?? 0) >= 1000000){
          setReward(child, Reward.master);
        }
      }
      hiveStorage.put(el, child!);
    }
    ListenOnValue.expensesNotifier.value++;
  }

  void setReward(ChildModel child, Reward reward){
    if(child.rewards[reward] == null){
      child.rewards[reward] = (0, true, false);
    } else {
      var it = child.rewards[reward]!;
      child.rewards[reward] = (it.$1, true, it.$3);
    }
  }

  Future<void> storeIncrements(SqfliteDB db, ChildModel child, Currency curr, DateTime today, int days) async{
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

  void startNewDay(Duration delay) {
    Future.delayed(delay, () async{
      await increaseExpenses(today: DateTime.now().dateOnly());
      startNewDay(Duration(days: 1));
    });
  }

}
