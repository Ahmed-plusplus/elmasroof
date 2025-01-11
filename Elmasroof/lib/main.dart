import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/network/local/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveStorage hiveStorage = await HiveStorage.getInstance();
  runApp(MyApp(hiveStorage: hiveStorage,));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.hiveStorage});
  HiveStorage hiveStorage;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elmasroof',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: HomeScreen(hiveStorage: hiveStorage,),
    );
  }
}