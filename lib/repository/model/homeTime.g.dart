// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homeTime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeTimeAdapter extends TypeAdapter<HomeTime> {
  @override
  final int typeId = 2;

  @override
  HomeTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeTime(
      enterTime: fields[0] as String,
      exitTime: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HomeTime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.enterTime)
      ..writeByte(1)
      ..write(obj.exitTime)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
