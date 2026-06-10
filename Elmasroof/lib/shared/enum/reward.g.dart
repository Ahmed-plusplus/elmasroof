// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardAdapter extends TypeAdapter<Reward> {
  @override
  final int typeId = 3;

  @override
  Reward read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Reward.goodBeginning;
      case 1:
        return Reward.dreamer;
      case 2:
        return Reward.bronze;
      case 3:
        return Reward.strong;
      case 4:
        return Reward.ambitious;
      case 5:
        return Reward.silver;
      case 6:
        return Reward.star;
      case 7:
        return Reward.hero;
      case 8:
        return Reward.golden;
      case 9:
        return Reward.shiny;
      case 10:
        return Reward.legend;
      case 11:
        return Reward.diamond;
      case 12:
        return Reward.master;
      default:
        return Reward.goodBeginning;
    }
  }

  @override
  void write(BinaryWriter writer, Reward obj) {
    switch (obj) {
      case Reward.goodBeginning:
        writer.writeByte(0);
        break;
      case Reward.dreamer:
        writer.writeByte(1);
        break;
      case Reward.bronze:
        writer.writeByte(2);
        break;
      case Reward.strong:
        writer.writeByte(3);
        break;
      case Reward.ambitious:
        writer.writeByte(4);
        break;
      case Reward.silver:
        writer.writeByte(5);
        break;
      case Reward.star:
        writer.writeByte(6);
        break;
      case Reward.hero:
        writer.writeByte(7);
        break;
      case Reward.golden:
        writer.writeByte(8);
        break;
      case Reward.shiny:
        writer.writeByte(9);
        break;
      case Reward.legend:
        writer.writeByte(10);
        break;
      case Reward.diamond:
        writer.writeByte(11);
        break;
      case Reward.master:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
