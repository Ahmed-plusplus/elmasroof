import 'package:hive/hive.dart';

part 'reward_data_model.g.dart';

@HiveType(typeId: 4)
class RewardDataModel {
  @HiveField(0)
  double value;
  @HiveField(1)
  bool isTaken;
  @HiveField(2)
  bool isShowed;

  RewardDataModel(this.value, this.isTaken, this.isShowed);
}