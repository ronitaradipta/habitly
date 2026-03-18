import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashAnimationProvider = StreamProvider.autoDispose<bool>((ref) async* {
  // Initial state is expanded
  bool isExpanded = true;
  yield isExpanded;

  // Toggle state every 1 second
  await for (final _ in Stream.periodic(const Duration(milliseconds: 1000))) {
    isExpanded = !isExpanded;
    yield isExpanded;
  }
});
