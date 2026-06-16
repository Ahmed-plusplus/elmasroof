import 'package:elmasroof/shared/enum/reward.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:hive/hive.dart';

part 'child_model.g.dart';

@HiveType(typeId: 1)
class ChildModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  Map<Currency,double> expenses;

  @HiveField(2)
  String stickerPath;

  @HiveField(3)
  Map<Currency,double> increment;

  @HiveField(4)
  DateTime? punishmentUntil;

  @HiveField(5)
  Map<Reward, (double value, bool isTaken, bool isShowed)> rewards;

  ChildModel({
    required this.name,
    required this.expenses,
    required this.stickerPath,
    required this.increment,
    this.punishmentUntil,
    required this.rewards,
  });
}