// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyAdapter extends TypeAdapter<Currency> {
  @override
  final int typeId = 2;

  @override
  Currency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Currency.pound;
      case 1:
        return Currency.dollar;
      case 2:
        return Currency.gold18;
      case 3:
        return Currency.gold21;
      case 4:
        return Currency.gold24;
      default:
        return Currency.pound;
    }
  }

  @override
  void write(BinaryWriter writer, Currency obj) {
    switch (obj) {
      case Currency.pound:
        writer.writeByte(0);
        break;
      case Currency.dollar:
        writer.writeByte(1);
        break;
      case Currency.gold18:
        writer.writeByte(2);
        break;
      case Currency.gold21:
        writer.writeByte(3);
        break;
      case Currency.gold24:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
