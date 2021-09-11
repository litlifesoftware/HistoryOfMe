// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 3;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      privacyPolicyAgreed: fields[0] as bool,
      darkMode: fields[1] as bool,
      tabIndex: fields[2] as int,
      installationID: fields[3] as String?,
      lastBackup: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.privacyPolicyAgreed)
      ..writeByte(1)
      ..write(obj.darkMode)
      ..writeByte(2)
      ..write(obj.tabIndex)
      ..writeByte(3)
      ..write(obj.installationID)
      ..writeByte(4)
      ..write(obj.lastBackup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
