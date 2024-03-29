// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendInfoAdapter extends TypeAdapter<FriendInfo> {
  @override
  final int typeId = 3;

  @override
  FriendInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendInfo(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
    )..atHome = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, FriendInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.atHome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
