import 'package:hive/hive.dart';

part 'currency.g.dart';

@HiveType(typeId: 2)
enum Currency {
  @HiveField(0)
  pound('Pound', 'assets/images/pound_icon.svg'),
  @HiveField(1)
  dollar('Dollar', 'assets/images/dollar_icon.svg'),
  @HiveField(2)
  gold18('Gold 18', 'assets/images/gold_bar_18.svg'),
  @HiveField(3)
  gold21('Gold 21', 'assets/images/gold_bar_21.svg'),
  @HiveField(4)
  gold24('Gold 24', 'assets/images/gold_bar_24.svg');

  final String name;
  final String icon;

  const Currency(
    this.name,
    this.icon,
  );
}