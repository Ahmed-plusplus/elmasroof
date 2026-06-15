extension DateTimeExtension on DateTime{
  DateTime dateOnly() => this.copyWith(
    microsecond: 0,
    millisecond: 0,
    second: 0,
    minute: 0,
    hour: 0,
  );
}