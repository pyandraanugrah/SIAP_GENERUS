import 'dart:io';
import 'package:flutter/material.dart';

class DefaultAvatar extends StatelessWidget {
  final double size;
  final String? imagePath;
  final BoxBorder? border;

  const DefaultAvatar({
    super.key,
    this.size = 58,
    this.imagePath,
    this.border,
  });

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
        child: _buildAvatarImage(),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildSilhouette();
    }

    try {
      final file = File(imagePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => _buildSilhouette(),
        );
      }
    } catch (_) {}

    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => _buildSilhouette(),
    );
  }

  Widget _buildSilhouette() {
    return Center(
      child: Icon(Icons.person_rounded, size: size * 0.72, color: Colors.white),
    );
  }
}
