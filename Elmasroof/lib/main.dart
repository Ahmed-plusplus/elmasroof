import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/modules/create_auth_screen.dart';
import 'package:elmasroof/modules/create_password_screen.dart';
import 'package:elmasroof/modules/enter_password_screen.dart';
import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/bloc_observer.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:workmanager/workmanager.dart';

bool _isSupported = false;
List<BiometricType> _availableBiometric = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveStorage.getInstance();
  await SqfliteDB.createDB();
  Bloc.observer = MyBlocObserver();
  await SharedManager.init();
  LocalAuthentication auth = LocalAuthentication();
  _isSupported = await auth.isDeviceSupported();
  _availableBiometric = await auth.getAvailableBiometrics();
  print(_isSupported);
  print(_availableBiometric);
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    "Elmasroof2",
    "dailyTask",
    frequency: const Duration(minutes: 15),
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: Duration(minutes: 1), // How long to wait before retrying
    initialDelay: Duration(/*hours: DateTime.now().hour, minutes: DateTime.now().minute, */seconds: 5)
    // initialDelay: Duration(hours: 24 - DateTime.now().hour, minutes: -DateTime.now().minute),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit(HiveStorage()),),
        BlocProvider(create: (context) => HistoryCubit(),),
      ],
      child: MaterialApp(
        title: 'Elmasroof',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

        ),
        home: (SharedManager.getData(key: SharedManager.LOGIN_PASSWORD) == null)
            ? CreatePasswordScreen(isSupported: _isSupported, availableBiometric: _availableBiometric)
            // : EnterPasswordScreen(isSupported: _isSupported, availableBiometric: _availableBiometric),
            : HomeScreen(),
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
