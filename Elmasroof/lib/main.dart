import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/bloc_observer.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveStorage.getInstance();
  await SqfliteDB.createDB();
  Bloc.observer = MyBlocObserver();
  await SharedManager.init();
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  //
  // Workmanager().registerPeriodicTask(
  //   "Elmasroof",
  //   "dailyTask",
  //   frequency: Duration(days: 1),
  //   initialDelay: Duration(hours: 24 - DateTime.now().hour, minutes: -DateTime.now().minute),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elmasroof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: const HomeScreen(),
    );
  }
}

void callbackDispatcher() {
  HiveStorage.getInstance();
  HiveStorage hiveStorage = HiveStorage();
  var list = hiveStorage.getKeys();
  for(var el in list){
    double x = hiveStorage.get(el);
    hiveStorage.put(el, x+10);
  }
}
