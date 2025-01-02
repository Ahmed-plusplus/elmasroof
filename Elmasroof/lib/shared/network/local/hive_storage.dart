import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {

  static const ELMASROOF = 'Elmasroof';

  late Box _box;

  HiveStorage({
    required String name,
  }) {
    _box = Hive.openBox(name) as Box;
  }

  List getKeys() => _box.toMap().keys.toList();

  void add(dynamic key, dynamic value) => _box.put(key, value);

  dynamic get(dynamic key) => _box.get(key);

}