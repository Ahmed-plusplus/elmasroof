// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardDataModelAdapter extends TypeAdapter<RewardDataModel> {
  @override
  final int typeId = 4;

  @override
  RewardDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardDataModel(
      fields[0] as double,
      fields[1] as bool,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RewardDataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.isTaken)
      ..writeByte(2)
      ..write(obj.isShowed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
