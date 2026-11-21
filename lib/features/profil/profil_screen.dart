import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../shared/widgets/default_avatar.dart';
import '../../shared/utils/avatar_picker_helper.dart';
import '../auth/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _dataStore.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataStore.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan Akun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: AppColors.primaryGreen,
                ),
                title: const Text('Edit Profil'),
                subtitle: const Text('Perbarui nama dan info profil'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditProfilDialog();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_reset_rounded,
                  color: AppColors.primaryGreen,
                ),
                title: const Text('Ubah Password'),
                subtitle: const Text('Perbarui kata sandi akun'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  _showChangePasswordDialog();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.badgeRed,
                ),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: AppColors.badgeRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Keluar dari sesi akun'),
                onTap: _isLoggingOut
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        _handleLogout();
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.badgeRed, size: 24),
            SizedBox(width: 10),
            Text(
              'Konfirmasi Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun SIAP-GENERUS?',
          style: TextStyle(color: AppColors.primaryText, fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.badgeRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await auth.signOut();
      }
    } catch (_) {}

    if (!mounted) return;

    _dataStore.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showEditProfilDialog() {
    final nameCtrl = TextEditingController(text: _dataStore.teacherName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                AvatarPickerHelper.pickAndSaveAvatar(context);
              },
              icon: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primaryGreen,
              ),
              label: const Text(
                'Ganti Foto Profil',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameCtrl.text.trim();
              if (newName.isNotEmpty) {
                _dataStore.updateTeacherProfile(name: newName);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui.'),
                  backgroundColor: AppColors.primaryGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Ubah Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Saat Ini',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPassCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password baru tidak boleh kosong.'),
                    backgroundColor: AppColors.badgeRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              if (newPassCtrl.text != confirmPassCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Konfirmasi password tidak cocok.'),
                    backgroundColor: AppColors.badgeRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password demo diperbarui untuk sesi ini.'),
                  backgroundColor: AppColors.primaryGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String title, int percent) {
    final safePercent = percent.clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              '$safePercent%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: safePercent / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5EDE8),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 190),
                      painter: _ProfilHeaderPainter(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 64,
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF86BA93), Color(0xFF388E4A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFD8AD43),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  AvatarPickerHelper.pickAndSaveAvatar(context),
                              child: Tooltip(
                                message: 'Ganti Foto Profil',
                                child: DefaultAvatar(
                                  size: 66,
                                  imagePath: _dataStore.avatarPath,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _dataStore.teacherName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _dataStore.teacherRole,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Text(
                                    'Akun Pengajar',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Text(
                                    'Status: Aktif',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Progres Belajar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressRow(
                          'Tilawah Al-Qur\'an',
                          _dataStore.tilawahProgress,
                        ),
                        _buildProgressRow(
                          'Hafalan Surat Pendek',
                          _dataStore.hafalanProgress,
                        ),
                        _buildProgressRow(
                          'Doa-Doa Pilihan',
                          _dataStore.doaProgress,
                        ),
                        _buildProgressRow(
                          'Aksara Pegon',
                          _dataStore.pegonProgress,
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F9F7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2EBE5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Penyelesaian Materi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Target semester genap',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreenBadge,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_dataStore.completedMaterialsCount} dari '
                                  '${_dataStore.totalMaterialsCount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: GestureDetector(
              onTap: _showSettingsModal,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.primaryText,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;

    final goldPath = Path();
    goldPath.moveTo(0, 0);
    goldPath.lineTo(size.width, 0);
    goldPath.lineTo(size.width, size.height * 0.95);
    goldPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.05,
      0,
      size.height * 0.95,
    );
    goldPath.close();
    canvas.drawPath(goldPath, goldPaint);

    final greenPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.fill;

    final greenPath = Path();
    greenPath.moveTo(0, 0);
    greenPath.lineTo(size.width, 0);
    greenPath.lineTo(size.width, size.height * 0.88);
    greenPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.98,
      0,
      size.height * 0.88,
    );
    greenPath.close();
    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
