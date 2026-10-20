import 'package:flutter/material.dart';

class DefaultAvatar extends StatelessWidget {
  final double size;
  final String? imagePath;
  final BoxBorder? border;

  const DefaultAvatar({super.key, this.size = 58, this.imagePath, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFCFD9DE),
        border: border,
      ),
      child: ClipOval(
        child: imagePath != null && imagePath!.isNotEmpty
            ? Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildSilhouette(),
              )
            : _buildSilhouette(),
      ),
    );
  }

  Widget _buildSilhouette() {
    return Center(
      child: Icon(Icons.person_rounded, size: size * 0.72, color: Colors.white),
    );
  }
}
