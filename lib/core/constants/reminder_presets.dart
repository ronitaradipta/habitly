class ReminderPreset {
  final String id;
  final String timeValue;
  final String displayTime;
  final String label;
  final String iconName;

  const ReminderPreset({
    required this.id,
    required this.timeValue,
    required this.displayTime,
    required this.label,
    required this.iconName,
  });
}

const reminderPresets = [
  ReminderPreset(
    id: 'morning',
    timeValue: '07:00',
    displayTime: '7:00 AM',
    label: 'Morning',
    iconName: 'wb_sunny_outlined',
  ),
  ReminderPreset(
    id: 'afternoon',
    timeValue: '13:00',
    displayTime: '1:00 PM',
    label: 'Afternoon',
    iconName: 'wb_cloudy_outlined',
  ),
  ReminderPreset(
    id: 'evening',
    timeValue: '19:00',
    displayTime: '7:00 PM',
    label: 'Evening',
    iconName: 'nightlight_outlined',
  ),
];
