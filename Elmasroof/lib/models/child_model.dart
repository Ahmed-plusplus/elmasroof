import 'package:hive/hive.dart';

part 'child_model.g.dart';

@HiveType(typeId: 1)
class ChildModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  double expenses;

  @HiveField(2)
  String stickerPath;

  ChildModel({
    required this.name,
    required this.expenses,
    required this.stickerPath,
  });
}