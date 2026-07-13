import 'package:hive/hive.dart';

part 'reward.g.dart';

@HiveType(typeId: 3)
enum Reward {
  @HiveField(0)
  goodBeginning('بداية جيدة', 'assets/images/good_beginning.svg', 'تمكن من ادخار 10% من مصروفه اليومى خلال شهر', 1),
  @HiveField(1)
  dreamer('حالم', 'assets/images/dreamer.svg', 'حقق مكسب 50% من المصروف الشهرى خلال شهر', 5),
  @HiveField(2)
  bronze('برونزى', 'assets/images/bronze.svg', 'تمكن من ادخار 100 جنيه', 9),
  @HiveField(3)
  strong('قوى', 'assets/images/strong.svg', 'تمكن من ادخار 25% من مصروفه اليومى خلال شهر', 2),
  @HiveField(4)
  ambitious('طموح', 'assets/images/ambitious.svg', 'حقق مكسب 80% من المصروف الشهرى خلال شهر', 6),
  @HiveField(5)
  silver('فضى', 'assets/images/silver.svg', 'تمكن من ادخار 1000 جنيه', 10),
  @HiveField(6)
  star('نجم', 'assets/images/star.svg', 'تمكن من ادخار 33.33% من مصروفه اليومى خلال شهر', 3),
  @HiveField(7)
  hero('بطل', 'assets/images/hero.svg', 'حقق مكسب 100% من المصروف الشهرى خلال شهر', 7),
  @HiveField(8)
  golden('ذهبى', 'assets/images/golden.svg', 'تمكن من ادخار 10 الاف جنيه', 11),
  @HiveField(9)
  shiny('ساطع', 'assets/images/shiny.svg', 'تمكن من ادخار 50% من مصروفه اليومى خلال شهر', 4),
  @HiveField(10)
  legend('اسطورة', 'assets/images/legend.svg', 'حقق مكسب 200% من المصروف الشهرى خلال شهر', 8),
  @HiveField(11)
  diamond('الماسى', 'assets/images/diamond.svg', 'تمكن من ادخار 100 الف جنيه', 12),
  @HiveField(12)
  master('مسيطر', 'assets/images/master.svg', 'تمكن من ادخار مليون جنيه', 13);

  final String name;
  final String iconPath;
  final String description;
  final int id;

  const Reward(this.name, this.iconPath, this.description, this.id);
}