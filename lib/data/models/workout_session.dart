import 'package:hive/hive.dart';

// 1. The Data Model
class WorkoutSession extends HiveObject {
  final DateTime date;
  final int count;
  final int durationSeconds;

  WorkoutSession({
    required this.date,
    required this.count,
    required this.durationSeconds,
  });
}

// 2. The Manual Adapter
// This tells Hive how to read/write this object strictly by index (0, 1, 2)
class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 0; // Unique ID for this type

  @override
  WorkoutSession read(BinaryReader reader) {
    // Read the number of fields
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Reconstruct the object
    return WorkoutSession(
      date: fields[0] as DateTime,
      count: fields[1] as int,
      durationSeconds: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    // Write the fields in order
    writer
      ..writeByte(3) // We have 3 fields
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.durationSeconds);
  }
}
