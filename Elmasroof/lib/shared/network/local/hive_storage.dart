import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {

  static const ELMASROOF = 'Elmasroof';

  static late Box _box;

  HiveStorage._();

  static Future<HiveStorage> getInstance() async {
    _box = await Hive.openBox(ELMASROOF);
    return HiveStorage._();
  }

  List getKeys() => _box.toMap().keys.toList();

  void add(dynamic key, dynamic value) => _box.put(key, value);

  dynamic get(dynamic key) => _box.get(key);

  dynamic getAt(int index) => _box.getAt(index);

  void remove(dynamic key) => _box.delete(key);

}