import 'package:elmasroof/models/child_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {

  static const ELMASROOF = 'Elmasroof';

  static late Box<ChildModel> _box;

  static Future<void> getInstance() async {
    Hive.registerAdapter(ChildModelAdapter());
    _box = await Hive.openBox<ChildModel>(ELMASROOF);
  }

  List getKeys() => _box.toMap().keys.toList();

  void put(dynamic key, ChildModel value) => _box.put(key, value);

  ChildModel? get(dynamic key) => _box.get(key);

  ChildModel? getAt(int index) => _box.getAt(index);

  void remove(dynamic key) => _box.delete(key);

}