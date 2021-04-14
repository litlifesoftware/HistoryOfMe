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
      name: fields[0] as String,
      primaryColor: fields[1] as int,
      secondaryColor: fields[2] as int,
      stripeCount: fields[3] as int,
      dotSize: fields[4] as int,
      animated: fields[5] as bool,
      quote: fields[6] as String,
      designPatternIndex: fields[7] as int,
      quoteAuthor: fields[8] as String,
      lastUpdated: fields[9] as int,
      created: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.primaryColor)
      ..writeByte(2)
      ..write(obj.secondaryColor)
      ..writeByte(3)
      ..write(obj.stripeCount)
      ..writeByte(4)
      ..write(obj.dotSize)
      ..writeByte(5)
      ..write(obj.animated)
      ..writeByte(6)
      ..write(obj.quote)
      ..writeByte(7)
      ..write(obj.designPatternIndex)
      ..writeByte(8)
      ..write(obj.quoteAuthor)
      ..writeByte(9)
      ..write(obj.lastUpdated)
      ..writeByte(10)
      ..write(obj.created);
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
