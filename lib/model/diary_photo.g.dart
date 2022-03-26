// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_photo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryPhotoAdapter extends TypeAdapter<DiaryPhoto> {
  @override
  final int typeId = 4;

  @override
  DiaryPhoto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryPhoto(
      uid: fields[0] as String,
      date: fields[1] as String,
      created: fields[2] as int,
      name: fields[3] as String,
      path: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryPhoto obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.created)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryPhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
