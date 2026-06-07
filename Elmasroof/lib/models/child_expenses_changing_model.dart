import 'package:elmasroof/shared/enum/currency.dart';

class ChildExpensesChangingModel{
  int? id;
  String name;
  (Currency, double) expenses;
  DateTime? dateTime;
  String description;
  (Currency, double) total;

  ChildExpensesChangingModel({
    this.id,
    required this.name,
    required this.expenses,
    this.dateTime,
    this.description = '',
    required this.total,
  }) {
    dateTime ??= DateTime.now();
  }
}