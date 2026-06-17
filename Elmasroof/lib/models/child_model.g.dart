// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildModelAdapter extends TypeAdapter<ChildModel> {
  @override
  final int typeId = 1;

  @override
  ChildModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildModel(
      name: fields[0] as String,
      expenses: (fields[1] as Map).cast<Currency, double>(),
      stickerPath: fields[2] as String,
      increment: (fields[3] as Map).cast<Currency, double>(),
      punishmentUntil: fields[4] as DateTime?,
      rewards: (fields[5] as Map).cast<Reward, RewardDataModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChildModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.expenses)
      ..writeByte(2)
      ..write(obj.stickerPath)
      ..writeByte(3)
      ..write(obj.increment)
      ..writeByte(4)
      ..write(obj.punishmentUntil)
      ..writeByte(5)
      ..write(obj.rewards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
