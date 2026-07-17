import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/cubit/daily_expenses_cubit/daily_expenses_cubit.dart';
import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/modules/splash_screen.dart';
import 'package:elmasroof/shared/bloc_observer.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/app_device_info.dart';
import 'package:elmasroof/shared/enums/currency.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
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
        BlocProvider(create: (context) => DailyExpensesCubit(),),
      ],
      child: MaterialApp(
        title: 'Elmasroof',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
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
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  await SharedManager.init();
  await AppDeviceInfo.init();
}
