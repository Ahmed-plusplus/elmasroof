import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/cubit/radio_group_cubit/radio_group_cubit.dart';
import 'package:elmasroof/modules/splash_screen.dart';
import 'package:elmasroof/shared/bloc_observer.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveStorage.getInstance();
  // await SqfliteDB.createDB();
  Bloc.observer = MyBlocObserver();
  await SharedManager.init();

  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Workmanager().registerPeriodicTask(
  //   "ElmasroofTEST",
  //   "dailyTask",
  //   frequency: const Duration(minutes: 15),
  //   backoffPolicy: BackoffPolicy.exponential,
  //   backoffPolicyDelay: Duration(minutes: 1), // How long to wait before retrying
  //   initialDelay: Duration(/*hours: DateTime.now().hour, minutes: DateTime.now().minute, */seconds: 5)
  //   // initialDelay: Duration(hours: 24 - DateTime.now().hour, minutes: -DateTime.now().minute),
  // );
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

void callbackDispatcher() async {
  await Hive.initFlutter();
  await HiveStorage.getInstance();
  HiveStorage hiveStorage = HiveStorage();
  var list = hiveStorage.getKeys();
  for(var el in list){
    double x = hiveStorage.get(el);
    hiveStorage.put(el, x+10);
  }
  ListenOnValue.expensesNotifier.value++;
  print('increase: ${DateTime.now()}');
}
