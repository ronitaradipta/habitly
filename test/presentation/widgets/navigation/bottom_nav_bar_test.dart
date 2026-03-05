import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly/core/constants/routes.dart';
import 'package:habitly/presentation/widgets/shared/navigation/bottom_nav_bar.dart';

void main() {
  testWidgets('navigates to profile route from home item state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(
          body: BottomNavBar(currentItem: BottomNavItem.home),
        ),
        routes: {
          AppRoutes.home: (_) => const Scaffold(body: Text('Home')),
          AppRoutes.profile: (_) =>
              const Scaffold(body: Text('Profile Page')),
          AppRoutes.addHabit: (_) => const Scaffold(body: Text('Add Habit')),
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.person_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Profile Page'), findsOneWidget);
  });

  testWidgets('shows filled profile icon when profile is active', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BottomNavBar(currentItem: BottomNavItem.profile),
        ),
      ),
    );

    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.person_outlined), findsNothing);
  });
}
