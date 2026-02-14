import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'type_ids.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = HiveTypeIds.habit;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      id: reader.read() as String,
      name: reader.read() as String,
      iconCodePoint: reader.read() as int,
      isCompleted: reader.read() as bool,
      completionTime: reader.read() as String?,
      reminderPeriod: _periodFromString(reader.read() as String?),
      targetDate: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.iconCodePoint);
    writer.write(obj.isCompleted);
    writer.write(obj.completionTime);
    writer.write(obj.reminderPeriod?.name);
    writer.write(obj.targetDate);
  }

  /// Deserialize ReminderPeriod enum from String name
  ReminderPeriod? _periodFromString(String? periodName) {
    if (periodName == null) return null;
    try {
      return ReminderPeriod.values.firstWhere((e) => e.name == periodName);
    } catch (_) {
      return null; // Return null if enum value not found
    }
  }
}
