import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {

  static const ELMASROOF = 'Elmasroof';

  static late Box _box;

  static Future<void> getInstance() async {
    _box = await Hive.openBox(ELMASROOF);
  }

  List getKeys() => _box.toMap().keys.toList();

  void put(dynamic key, dynamic value) => _box.put(key, value);

  dynamic get(dynamic key) => _box.get(key);

  dynamic getAt(int index) => _box.getAt(index);

  void remove(dynamic key) => _box.delete(key);

}