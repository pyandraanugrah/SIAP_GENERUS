import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../generus/generus_list_screen.dart';
import '../absensi/absensi_screen.dart';
import '../progress/progress_screen.dart';
import '../prestasi/prestasi_screen.dart';
import '../pengajar/pengajar_list_screen.dart';
import '../kelas/kelas_list_screen.dart';
import '../pembinaan/pembinaan_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  void _showExtraModulesModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modul Pengelolaan Tambahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.lightGreenBadge,
                child: Icon(Icons.school_rounded, color: AppColors.primaryGreen),
              ),
              title: const Text('Data Pengajar', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${_dataStore.pengajarList.length} Pengajar terdaftar'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PengajarListScreen()));
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.lightGreenBadge,
                child: Icon(Icons.meeting_room_rounded, color: AppColors.primaryGreen),
              ),
              title: const Text('Data Kelas & Jenjang', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${_dataStore.kelasList.length} Kelas (PAUD, SD, SMP, SMA)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const KelasListScreen()));
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.lightGreenBadge,
                child: Icon(Icons.assignment_ind_rounded, color: AppColors.primaryGreen),
              ),
              title: const Text('Catatan Pembinaan', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${_dataStore.pembinaanList.length} Catatan tindak lanjut'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PembinaanScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Stack with curved green + gold wave + floating profile card
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Curved background
                CustomPaint(
                  size: const Size(double.infinity, 190),
                  painter: _DashboardHeaderPainter(),
                ),

                // Floating Profile Card
                Padding(
                  padding: const EdgeInsets.only(top: 64, left: 20, right: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightGreen,
                            border: Border.all(color: AppColors.border, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'references/Dashboard-Generus.png',
                              fit: BoxFit.none,
                              alignment: const Alignment(-0.65, -0.68),
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                color: AppColors.primaryGreen,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Profile Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _dataStore.teacherName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _dataStore.teacherRole,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Selamat Pagi !',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // More options shortcut
                        IconButton(
                          icon: const Icon(Icons.tune_rounded, color: AppColors.primaryGreen),
                          tooltip: 'Semua Modul',
                          onPressed: _showExtraModulesModal,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Statistics Section (2 columns matching screenshot)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column: Total Generus + Kelas Aktif
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          // Total Generus Card
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GenerusListScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E6E3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Generus',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${_dataStore.totalGenerus}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGreenBadge,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              '+5%',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.secondaryGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.groups_rounded,
                                        color: AppColors.primaryGreen,
                                        size: 32,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kelas Aktif Card (Dark Green)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const KelasListScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenCard,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.darkGreenCard.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kelas Aktif',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_dataStore.totalKelas}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Right Column: Rata Rata Kehadiran Card
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E6E3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rata Rata\nKehadiran',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Circular Ring
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: CircularProgressIndicator(
                                      value: _dataStore.attendanceRate / 100,
                                      strokeWidth: 7,
                                      backgroundColor: const Color(0xFFE4ECE7),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryGreen,
                                      ),
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  Text(
                                    '${_dataStore.attendanceRate}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Red pill -9%
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.badgeRedBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '-9%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.badgeRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Fitur Utama Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Fitur Utama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 2x2 Feature Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Card 1: Data Generus
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.people_alt_rounded,
                          iconColor: AppColors.primaryGreen,
                          title: 'Data Generus',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const GenerusListScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Card 2: Absensi
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.event_available_rounded,
                          iconColor: AppColors.primaryGreen,
                          title: 'Absensi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AbsensiScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Card 3: Progres Belajar
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.bar_chart_rounded,
                          iconColor: AppColors.primaryGreen,
                          title: 'Progres Belajar',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ProgressScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Card 4: Prestasi
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.emoji_events_rounded,
                          iconColor: AppColors.accentGold,
                          title: 'Prestasi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PrestasiScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E6E3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 38),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGreen, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeaderPainter extends CustomPainter {
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
