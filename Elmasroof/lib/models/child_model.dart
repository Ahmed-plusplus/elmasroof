class ChildModel{
  String name;
  double expenses;
  DateTime? dateTime;

  ChildModel({
    required this.name,
    required this.expenses,
    this.dateTime,
  });
}