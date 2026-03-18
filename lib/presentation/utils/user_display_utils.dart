import 'package:habitly/domain/entities/user.dart';

String getUserInitials(User user) {
  final nameParts = user.fullName.trim().split(' ');
  if (nameParts.isEmpty) return 'U';

  final firstInitial =
      nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : '';

  if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
    final secondInitial = nameParts[1][0].toUpperCase();
    return '$firstInitial$secondInitial';
  }

  return firstInitial;
}
