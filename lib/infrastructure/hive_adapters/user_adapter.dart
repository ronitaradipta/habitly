import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitly/domain/entities/user.dart';
import 'type_ids.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = HiveTypeIds.user;

  @override
  User read(BinaryReader reader) {
    final email = reader.read() as String;
    final fullName = reader.read() as String;
    final mobile = reader.read() as String;
    final gender = reader.read() as String;
    final loggedInAt = reader.read() as DateTime;
    final hasCompletedOnboarding = reader.read() as bool;
    return User(
      email: email,
      fullName: fullName,
      mobile: mobile,
      gender: gender,
      loggedInAt: loggedInAt,
      hasCompletedOnboarding: hasCompletedOnboarding,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.email);
    writer.write(obj.fullName);
    writer.write(obj.mobile);
    writer.write(obj.gender);
    writer.write(obj.loggedInAt);
    writer.write(obj.hasCompletedOnboarding);
  }
}
