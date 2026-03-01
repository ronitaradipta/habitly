import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/services/local_notification_service.dart';
import 'package:habitly/injection_container.dart' as di;

final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (_) => di.getIt<LocalNotificationService>(),
);
