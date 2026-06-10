import 'package:hive/hive.dart';

part 'reward.g.dart';

@HiveType(typeId: 3)
enum Reward {
  @HiveField(0)
  goodBeginning('بداية جيدة', 'assets/images/good_beginning.svg'), //تحويش 10% من المصروف اليومى خلال شهر
  @HiveField(1)
  dreamer('حالم', 'assets/images/dreamer.svg'), //تحقيق مكسب 50% من المصروف الشهرى خلال شهر
  @HiveField(2)
  bronze('برونزى', 'assets/images/bronze.svg'), // تحويش 100 جنيه
  @HiveField(3)
  strong('قوى', 'assets/images/strong.svg'), //تحويش 25% من المصروف اليومى خلال شهر
  @HiveField(4)
  ambitious('طموح', 'assets/images/ambitious.svg'), //تحقيق مكسب 80% من المصروف الشهرى خلال شهر
  @HiveField(5)
  silver('فضى', 'assets/images/silver.svg'), // تحويش 1k جنيه
  @HiveField(6)
  star('نجم', 'assets/images/star.svg'), //تحويش 33.33% من المصروف اليومى خلال شهر
  @HiveField(7)
  hero('بطل', 'assets/images/hero.svg'), //تحقيق مكسب 100% من المصروف الشهرى خلال شهر
  @HiveField(8)
  golden('ذهبى', 'assets/images/golden.svg'), // تحويش 10k جنيه
  @HiveField(9)
  shiny('ساطع', 'assets/images/shiny.svg'), //تحويش 50% من المصروف اليومى خلال شهر
  @HiveField(10)
  legend('اسطورة', 'assets/images/legend.svg'), //تحقيق مكسب 200% من المصروف الشهرى خلال شهر
  @HiveField(11)
  diamond('الماسى', 'assets/images/diamond.svg'), // تحويش 100K جنيه
  @HiveField(12)
  master('مسيطر', 'assets/images/master.svg'); // تحويش 1M جنيه

  final String name;
  final String iconPath;

  const Reward(this.name, this.iconPath);
}