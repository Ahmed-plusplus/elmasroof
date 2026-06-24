import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/models/reward_data_model.dart';
import 'package:elmasroof/shared/enum/reward.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {

  static const ELMASROOF = 'Elmasroof';

  static late Box<ChildModel> _box;

  static Future<void> getInstance() async {
    Hive.registerAdapter(CurrencyAdapter());
    Hive.registerAdapter(RewardAdapter());
    Hive.registerAdapter(RewardDataModelAdapter());
    Hive.registerAdapter(ChildModelAdapter());

    _box = await Hive.openBox<ChildModel>(ELMASROOF);
  }

  List getKeys() => _box.toMap().keys.toList();

  void put(dynamic key, ChildModel value) => _box.put(key, value);

  ChildModel? get(dynamic key) => _box.get(key);

  ChildModel? getAt(int index) => _box.getAt(index);

  void remove(dynamic key) => _box.delete(key);

}