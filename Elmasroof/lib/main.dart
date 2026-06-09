import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/modules/splash_screen.dart';
import 'package:elmasroof/shared/bloc_observer.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  handleIncrementalExpenses();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(),),
        BlocProvider(create: (context) => HomeCubit(HiveStorage()),),
        BlocProvider(create: (context) => HistoryCubit(),),
      ],
      child: MaterialApp(
        title: 'Elmasroof',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

        ),
        home: const SplashScreen()
      ),
    );
  }
}

Future<void> init() async{
  await Hive.initFlutter();
  await HiveStorage.getInstance();
  await SqfliteDB.createDB();
  Bloc.observer = MyBlocObserver();
  await SharedManager.init();
}

void handleIncrementalExpenses(){
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
    increaseExpenses(days: numberOfDays);
    SharedManager.putData(
        key: SharedManager.LAST_DATE, value: currentDate.toIso8601String());
  }
  var nextDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
  var delay = nextDate.difference(currentDate);
  startNewDay(delay);
}

void increaseExpenses({int days = 1}) async {
  HiveStorage hiveStorage = HiveStorage();
  var list = hiveStorage.getKeys();
  for(var el in list){
    var child = hiveStorage.get(el);
    for(var curr in Currency.values) {
      child!.expenses[curr] = (child.expenses[curr] ?? 0) + (child.increment[curr] ?? 0) * days;
    }
    hiveStorage.put(el, child!);
  }
  ListenOnValue.expensesNotifier.value++;
}

void startNewDay(Duration delay) {
  Future.delayed(delay, () {
    increaseExpenses();
    startNewDay(Duration(days: 1));
  });
}