import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool hasShadow;

  const AppLogo({super.key, this.size = 90, this.hasShadow = true});

  @override
  Widget build(BuildContext context) {
    final radius = size * (24.0 / 90.0);
    final iconSize = size * (46.0 / 90.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.secondaryGreen.withValues(alpha: 0.3),
                  blurRadius: size * (16.0 / 90.0),
                  offset: Offset(0, size * (8.0 / 90.0)),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
