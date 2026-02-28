import 'package:flutter/material.dart';
import 'package:habitly/core/theme/app_colors.dart';
import 'package:habitly/presentation/widgets/shared/buttons/theme_switch_button.dart';

class ThemeScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final Widget body;
  final Widget? drawer;

  const ThemeScaffold({
    super.key,
    this.backgroundColor,
    required this.body,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? colors.background,
      drawer: drawer,
      body: SafeArea(
        child: Stack(
          children: [
            body,
            const Positioned(top: 16, right: 16, child: ThemeSwitchButton()),
          ],
        ),
      ),
    );
  }
}
