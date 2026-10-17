import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;

  void _showReportDetail(LaporanModel item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenBadge,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.secondaryText),
                const SizedBox(width: 6),
                Text(
                  'Tanggal: ${item.date}',
                  style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Status: ${item.status}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ringkasan Laporan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5EDE8)),
              ),
              child: Text(
                item.summary,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showCategorySummary(String categoryName, String desc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori: $categoryName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentReports = _dataStore.laporanList.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Curved Header Banner
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6DFDC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 26),
                  ),
                  const Column(
                    children: [
                      Text(
                        'SIAP-GENERUS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Laporan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Title: "Pusat Laporan"
            const Center(
              child: Text(
                'Pusat Laporan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Section 1: "Laporan Terkini"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Laporan Terkini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 3 Recent Report Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: recentReports.map((item) {
                  return GestureDetector(
                    onTap: () => _showReportDetail(item),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreenBadge,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              Text(
                                item.date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: "Kategori Laporan"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Kategori Laporan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 4 Category Cards in Row / Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _CategorySquareCard(
                    title: 'Generus',
                    icon: Icons.people_outline_rounded,
                    onTap: () => _showCategorySummary('Generus', 'Kumpulan rekapitulasi data demografi, data orang tua, dan mutasi peserta generus.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Kelas',
                    icon: Icons.meeting_room_outlined,
                    onTap: () => _showCategorySummary('Kelas', 'Laporan distribusi kelas jenjang PAUD, SD, SMP, hingga SMA dan pengajar pengampu.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Absensi',
                    icon: Icons.event_available_outlined,
                    onTap: () => _showCategorySummary('Absensi', 'Statistik rekap kehadiran, persentase hadir, izin, sakit, dan tanpa keterangan.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Materi',
                    icon: Icons.menu_book_outlined,
                    onTap: () => _showCategorySummary('Materi', 'Pencapaian kurikulum Tilawah, Hafalan Al-Qur\'an, Doa harian, dan Pegon.'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Additional Category Row (Bulanan, Pembinaan, Prestasi, dsb.)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _CategorySquareCard(
                    title: 'Progress',
                    icon: Icons.trending_up_rounded,
                    onTap: () => _showCategorySummary('Progress', 'Grafik perkembangan capaian belajar setiap jenjang dan generus.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Pembinaan',
                    icon: Icons.assignment_ind_outlined,
                    onTap: () => _showCategorySummary('Pembinaan', 'Catatan tindak lanjut bimbingan kepribadian dan akhlak generus.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Prestasi',
                    icon: Icons.emoji_events_outlined,
                    onTap: () => _showCategorySummary('Prestasi', 'Rekapitulasi piagam dan prestasi generasi muda di berbagai tingkatan.'),
                  ),
                  const SizedBox(width: 10),
                  _CategorySquareCard(
                    title: 'Bulanan',
                    icon: Icons.calendar_month_outlined,
                    onTap: () => _showCategorySummary('Bulanan', 'Ringkasan komprehensif amalan dan target pembinaan setiap akhir bulan.'),
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

class _CategorySquareCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategorySquareCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 74,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 24),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
