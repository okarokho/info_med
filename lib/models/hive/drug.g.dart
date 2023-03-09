// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrugsAdapter extends TypeAdapter<Drugs> {
  @override
  final int typeId = 0;

  @override
  Drugs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drugs(
      name: fields[0] as String,
      description: fields[1] as String,
      instruction: fields[2] as String,
      sideEffect: fields[3] as String,
      image: fields[4] as String,
      language: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Drugs obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.instruction)
      ..writeByte(3)
      ..write(obj.sideEffect)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrugsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
