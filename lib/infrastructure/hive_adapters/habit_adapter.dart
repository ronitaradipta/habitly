import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitly/data/models/habit_model.dart';
import 'type_ids.dart';

class HabitAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = HiveTypeIds.habit;

  @override
  HabitModel read(BinaryReader reader) {
    return HabitModel(
      id: reader.read() as String,
      name: reader.read() as String,
      iconCodePoint: reader.read() as int,
      isCompleted: reader.read() as bool,
      completionTime: reader.read() as String?,
      reminderPeriodName: reader.read() as String?,
      targetDate: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.iconCodePoint);
    writer.write(obj.isCompleted);
    writer.write(obj.completionTime);
    writer.write(obj.reminderPeriodName);
    writer.write(obj.targetDate);
  }
}
