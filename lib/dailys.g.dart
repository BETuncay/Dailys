// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailys.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyDataAdapter extends TypeAdapter<DailyData> {
  @override
  final int typeId = 0;

  @override
  DailyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyData(
      fields[0] as int,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.task);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyHistoryAdapter extends TypeAdapter<DailyHistory> {
  @override
  final int typeId = 1;

  @override
  DailyHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyHistory(
      fields[0] as DateTime,
      (fields[1] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyHistory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.dailys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
