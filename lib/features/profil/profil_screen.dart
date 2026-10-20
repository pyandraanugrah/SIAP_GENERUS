import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../shared/widgets/default_avatar.dart';
import '../auth/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;

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
                'Pengaturan Akun Demo',
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
                subtitle: const Text('Perbarui nama dan info profil lokal'),
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
                subtitle: const Text('Simulasi ganti password akun'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  _showChangePasswordDialog();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primaryGreen,
                ),
                title: const Text('Ganti Foto Profil'),
                subtitle: const Text('Simulasi pemilihan avatar'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulasi: Foto profil lokal diperbarui!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.badgeRed,
                ),
                title: const Text(
                  'Logout Demo',
                  style: TextStyle(
                    color: AppColors.badgeRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Keluar dari sesi demo aplikasi'),
                onTap: () {
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
          'Apakah Anda yakin ingin keluar dari akun demo SIAP-GENERUS?',
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

    if (confirmed == true && mounted) {
      _dataStore.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil keluar dari akun demo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showEditProfilDialog() {
    final nameCtrl = TextEditingController(text: _dataStore.studentName);
    final nisnCtrl = TextEditingController(text: _dataStore.studentNisn);
    final kelasCtrl = TextEditingController(text: _dataStore.studentKelas);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Edit Profil Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: kelasCtrl,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nisnCtrl,
              decoration: const InputDecoration(labelText: 'NISN'),
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
              setState(() {
                _dataStore.studentName = nameCtrl.text.trim();
                _dataStore.studentKelas = kelasCtrl.text.trim();
                _dataStore.studentNisn = nisnCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui secara lokal!'),
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
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Password Demo'),
        content: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password Baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password berhasil disimulasikan!'),
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
              '$percent%',
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
            value: percent / 100,
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
                // Top Header Curve Stack
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 190),
                      painter: _ProfilHeaderPainter(),
                    ),

                    // Profile Header Card (Green Gradient)
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
                            // Student Avatar
                            DefaultAvatar(
                              size: 66,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            const SizedBox(width: 16),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _dataStore.studentName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _dataStore.studentRole,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    _dataStore.studentKelas,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'NISN : ${_dataStore.studentNisn}',
                                    style: const TextStyle(
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

                // Section Title: "Progres Belajar"
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

                // Large Progres Belajar Card
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

                        // Materi completion badge
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
                                  '${_dataStore.completedMaterialsCount} dari ${_dataStore.totalMaterialsCount}',
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

          // Floating Settings Button at bottom right
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
    // Gold Wave background accent
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

    // Green primary header
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
