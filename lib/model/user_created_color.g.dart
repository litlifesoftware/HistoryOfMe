// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_created_color.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCreatedColorAdapter extends TypeAdapter<UserCreatedColor> {
  @override
  final int typeId = 1;

  @override
  UserCreatedColor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCreatedColor(
      uid: fields[0] as String,
      alpha: fields[1] as int,
      red: fields[2] as int,
      green: fields[3] as int,
      blue: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserCreatedColor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.alpha)
      ..writeByte(2)
      ..write(obj.red)
      ..writeByte(3)
      ..write(obj.green)
      ..writeByte(4)
      ..write(obj.blue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCreatedColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
