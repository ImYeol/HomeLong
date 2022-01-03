// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knockFeed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KnockFeedAdapter extends TypeAdapter<KnockFeed> {
  @override
  final int typeId = 4;

  @override
  KnockFeed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KnockFeed(
      senderId: fields[0] as String,
      receiverId: fields[1] as String,
      sentTime: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KnockFeed obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.receiverId)
      ..writeByte(2)
      ..write(obj.sentTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnockFeedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
