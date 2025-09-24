import 'package:flutter/material.dart';

/// Custom AppBar widget with consistent styling and back button functionality
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? Colors.grey.shade800,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.deepPurple.shade50,
      elevation: elevation,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      automaticallyImplyLeading: false,
      centerTitle: false,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.grey.shade700,
          size: 20,
        ),
        tooltip: 'Go Back',
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom AppBar for screens with special requirements
class CustomAppBarWithBadge extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String badgeText;
  final Color badgeColor;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBarWithBadge({
    super.key,
    required this.title,
    required this.badgeText,
    required this.badgeColor,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      backgroundColor: Colors.deepPurple.shade50,
      elevation: 0,
      leading: showBackButton ? _buildBackButton(context) : null,
      actions: [
        ...?actions,
        Container(
          margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.grey.shade700,
          size: 20,
        ),
        tooltip: 'Go Back',
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Floating back button for screens without app bars
class FloatingBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? top;
  final double? left;

  const FloatingBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.top,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? MediaQuery.of(context).padding.top + 16,
      left: left ?? 16,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: iconColor ?? Colors.grey.shade700,
            size: 20,
          ),
          tooltip: 'Go Back',
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }
}
