import 'package:elmasroof/models/reward_data_model.dart';
import 'package:elmasroof/shared/enums/reward.dart';
import 'package:elmasroof/shared/enums/currency.dart';
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
  Map<Reward, RewardDataModel> rewards;

  @HiveField(6)
  String? otherParentId;

  ChildModel({
    required this.name,
    required this.expenses,
    required this.stickerPath,
    required this.increment,
    this.punishmentUntil,
    required this.rewards,
    this.otherParentId,
  });

  ChildModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        expenses = (json['expenses'] as Map<String, dynamic>).map((key, value) =>
            MapEntry(Currency.values.firstWhere((c) => c.id == int.parse(key)), value.toDouble())),
        stickerPath = json['stickerPath'],
        increment = (json['increment'] as Map<String, dynamic>).map((key, value) =>
            MapEntry(Currency.values.firstWhere((c) => c.id == int.parse(key)), value.toDouble())),
        punishmentUntil = json['punishmentUntil'] != null
            ? DateTime.parse(json['punishmentUntil'])
            : null,
        rewards = (json['rewards'] as Map<String, dynamic>).map((key, rewardData) =>
            MapEntry(Reward.values.firstWhere((reward) => reward.id == int.parse(key)),
                RewardDataModel.fromJson(rewardData))),
        otherParentId = json['otherParentId'];

  Map<String, dynamic> toMap() => {
    'name': name,
    'expenses': expenses.map((currency, amount) =>
        MapEntry(currency.id.toString(), amount)),
    'stickerPath': stickerPath,
    'increment': increment.map((currency, amount) =>
        MapEntry(currency.id.toString(), amount)),
    'punishmentUntil': punishmentUntil?.toIso8601String(),
    'rewards': rewards.map((reward, rewardData) =>
        MapEntry(reward.id.toString(), rewardData.toMap())),
    'otherParentId': otherParentId,
  };
}