class ChildExpensesChangingModel{
  int? id;
  String name;
  double expenses;
  DateTime? dateTime;
  String description;
  double total;

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