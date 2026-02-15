import 'package:flutter/material.dart';

class PresetHabit {
  final String id;
  final String name;
  final int iconCodePoint;

  const PresetHabit({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });
}

final List<PresetHabit> presetHabits = [
  PresetHabit(
    id: 'take_picture',
    name: 'Take Picture',
    iconCodePoint: Icons.camera_alt_outlined.codePoint,
  ),
  PresetHabit(
    id: 'workout',
    name: 'Workout',
    iconCodePoint: Icons.fitness_center.codePoint,
  ),
  PresetHabit(
    id: 'journaling',
    name: 'Journaling',
    iconCodePoint: Icons.edit_outlined.codePoint,
  ),
  PresetHabit(
    id: 'planning',
    name: 'Planning',
    iconCodePoint: Icons.calendar_month_outlined.codePoint,
  ),
  PresetHabit(
    id: 'game_tracking',
    name: 'Game Tracking',
    iconCodePoint: Icons.sports_esports_outlined.codePoint,
  ),
  PresetHabit(
    id: 'reading',
    name: 'Reading',
    iconCodePoint: Icons.menu_book_outlined.codePoint,
  ),
  PresetHabit(
    id: 'music_time',
    name: 'Music time',
    iconCodePoint: Icons.music_note_outlined.codePoint,
  ),
  PresetHabit(
    id: 'sleep_early',
    name: 'Sleep Early',
    iconCodePoint: Icons.bed_outlined.codePoint,
  ),
];
