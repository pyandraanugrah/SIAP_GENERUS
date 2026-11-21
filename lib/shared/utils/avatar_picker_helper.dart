import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';

class AvatarPickerHelper {
  const AvatarPickerHelper._();

  static Future<void> pickAndSaveAvatar(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null || !context.mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Pratinjau Foto Profil',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.file(
                  File(pickedFile.path),
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx2, err, st) => const Icon(
                    Icons.person_rounded,
                    size: 80,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gunakan foto ini sebagai foto profil?',
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      await DummyDataStore.instance.updateAvatarPath(savedFile.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diperbarui.'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: AppColors.badgeRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
