import 'package:flutter/material.dart';

Future<TimeOfDay?> showAppTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? const TimeOfDay(hour: 8, minute: 0),
  );
}
