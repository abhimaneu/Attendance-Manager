// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjectmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class subjectModelAdapter extends TypeAdapter<subject_Model> {
  @override
  final int typeId = 0;

  @override
  subject_Model read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return subject_Model(
      days: fields[0] as dynamic,
      name: fields[1] as dynamic,
      presnetdaysinhive: fields[2] as dynamic,
      absentdaysinhive: fields[3] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, subject_Model obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.presnetdaysinhive)
      ..writeByte(3)
      ..write(obj.absentdaysinhive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is subjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
