// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key, // Corrected super.key
    required this.titleText, // Corrected required parameter syntax
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText),
      centerTitle: true,
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16), // Rounded bottom corners for app bar
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard app bar height
}
