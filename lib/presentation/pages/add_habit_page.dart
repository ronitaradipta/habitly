import 'package:flutter/material.dart';
import 'package:habitly/presentation/widgets/habit/habit_form.dart';

class AddHabitPage extends StatelessWidget {
  const AddHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HabitForm(mode: FormMode.create);
  }
}
