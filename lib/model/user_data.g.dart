// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      name: fields[0] as String?,
      bookmarkColor: fields[1] as int?,
      stripeCount: fields[2] as int?,
      dotSize: fields[3] as int?,
      animated: fields[4] as bool?,
      quote: fields[5] as String?,
      designPatternIndex: fields[6] as int?,
      quoteAuthor: fields[7] as String?,
      lastUpdated: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bookmarkColor)
      ..writeByte(2)
      ..write(obj.stripeCount)
      ..writeByte(3)
      ..write(obj.dotSize)
      ..writeByte(4)
      ..write(obj.animated)
      ..writeByte(5)
      ..write(obj.quote)
      ..writeByte(6)
      ..write(obj.designPatternIndex)
      ..writeByte(7)
      ..write(obj.quoteAuthor)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
