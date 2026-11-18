
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';
import '../../shared/widgets/default_avatar.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final FirestoreService _firestore = FirestoreService.instance;

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${item.date}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
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
            const SizedBox(height: 12),
            Text(
              'Status: ${item.status}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
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
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _today() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }

  Widget _buildReportContent({
    required List<GenerusModel> generus,
    required List<KelasModel> kelas,
    required List<MateriModel> materi,
    required List<PertemuanModel> pertemuan,
    required List<PrestasiModel> prestasi,
  }) {
    final reports = <LaporanModel>[
      LaporanModel(
        id: 'generus',
        title: 'Laporan Data Generus',
        date: _today(),
        category: 'Generus',
        summary:
            'Saat ini terdapat ${generus.length} data generus yang tersimpan '
            'di Firebase. Data mencakup identitas, kelas, jenjang, dan '
            'informasi orang tua.',
        status: 'Terhubung',
      ),
      LaporanModel(
        id: 'kelas',
        title: 'Laporan Data Kelas',
        date: _today(),
        category: 'Kelas',
        summary:
            'Terdapat ${kelas.length} kelas yang terdaftar. '
            'Data kelas mencakup nama kelas, jenjang, pengajar, '
            'dan jumlah peserta.',
        status: 'Terhubung',
      ),
      LaporanModel(
        id: 'materi',
        title: 'Laporan Data Materi',
        date: _today(),
        category: 'Materi',
        summary:
            'Terdapat ${materi.length} materi pembelajaran yang tersimpan. '
            'Materi mencakup kategori, ringkasan, detail, '
            'dan progres pembelajaran.',
        status: 'Terhubung',
      ),
      LaporanModel(
        id: 'pertemuan',
        title: 'Laporan Kegiatan Pertemuan',
        date: _today(),
        category: 'Pertemuan',
        summary:
            'Terdapat ${pertemuan.length} pertemuan yang tercatat. '
            'Informasi meliputi judul kegiatan, tanggal, waktu, '
            'lokasi, dan status pertemuan.',
        status: 'Terhubung',
      ),
      LaporanModel(
        id: 'prestasi',
        title: 'Laporan Prestasi Generus',
        date: _today(),
        category: 'Prestasi',
        summary:
            'Terdapat ${prestasi.length} prestasi yang sudah dicatat. '
            'Data mencakup nama generus, judul prestasi, kategori, '
            'tingkat, tanggal, dan dokumentasi.',
        status: 'Terhubung',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: reports.map((item) {
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _CategorySquareCard(
                title: 'Generus',
                icon: Icons.people_outline_rounded,
                onTap: () => _showCategorySummary(
                  'Generus',
                  'Jumlah data generus: ${generus.length} orang. '
                  'Data diambil langsung dari Firebase.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Kelas',
                icon: Icons.meeting_room_outlined,
                onTap: () => _showCategorySummary(
                  'Kelas',
                  'Jumlah kelas terdaftar: ${kelas.length}. '
                  'Data mencakup jenjang dan pengajar.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Absensi',
                icon: Icons.event_available_outlined,
                onTap: () => _showCategorySummary(
                  'Absensi',
                  'Terdapat ${pertemuan.length} pertemuan yang dapat '
                  'memiliki catatan absensi. Data absensi disimpan '
                  'berdasarkan masing-masing pertemuan.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Materi',
                icon: Icons.menu_book_outlined,
                onTap: () => _showCategorySummary(
                  'Materi',
                  'Jumlah materi pembelajaran: ${materi.length}. '
                  'Materi dikelola berdasarkan kategori pembelajaran.',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _CategorySquareCard(
                title: 'Progress',
                icon: Icons.trending_up_rounded,
                onTap: () => _showCategorySummary(
                  'Progress',
                  'Data progres belajar terhubung dengan ${generus.length} '
                  'generus. Progres disimpan berdasarkan kategori '
                  'pembelajaran masing-masing generus.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Pembinaan',
                icon: Icons.assignment_ind_outlined,
                onTap: () => _showCategorySummary(
                  'Pembinaan',
                  'Bagian pembinaan masih berupa informasi. '
                  'Data pembinaan belum diintegrasikan ke Firestore.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Prestasi',
                icon: Icons.emoji_events_outlined,
                onTap: () => _showCategorySummary(
                  'Prestasi',
                  'Jumlah prestasi yang tercatat: ${prestasi.length}. '
                  'Data diambil langsung dari Firebase.',
                ),
              ),
              const SizedBox(width: 10),
              _CategorySquareCard(
                title: 'Bulanan',
                icon: Icons.calendar_month_outlined,
                onTap: () => _showCategorySummary(
                  'Ringkasan Data',
                  'Saat ini terdapat ${generus.length} generus, '
                  '${kelas.length} kelas, ${materi.length} materi, '
                  '${pertemuan.length} pertemuan, dan '
                  '${prestasi.length} prestasi yang tercatat.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 44,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat laporan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: StreamBuilder<List<GenerusModel>>(
        stream: _firestore.watchGenerus(),
        builder: (context, generusSnapshot) {
          if (generusSnapshot.hasError) {
            return _buildError(generusSnapshot.error!);
          }
          if (!generusSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<KelasModel>>(
            stream: _firestore.watchKelas(),
            builder: (context, kelasSnapshot) {
              if (kelasSnapshot.hasError) {
                return _buildError(kelasSnapshot.error!);
              }
              if (!kelasSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return StreamBuilder<List<MateriModel>>(
                stream: _firestore.watchMateri(),
                builder: (context, materiSnapshot) {
                  if (materiSnapshot.hasError) {
                    return _buildError(materiSnapshot.error!);
                  }
                  if (!materiSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return StreamBuilder<List<PertemuanModel>>(
                    stream: _firestore.watchPertemuan(),
                    builder: (context, pertemuanSnapshot) {
                      if (pertemuanSnapshot.hasError) {
                        return _buildError(pertemuanSnapshot.error!);
                      }
                      if (!pertemuanSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return StreamBuilder<List<PrestasiModel>>(
                        stream: _firestore.watchPrestasi(),
                        builder: (context, prestasiSnapshot) {
                          if (prestasiSnapshot.hasError) {
                            return _buildError(prestasiSnapshot.error!);
                          }
                          if (!prestasiSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top + 8,
                                    left: 20,
                                    right: 20,
                                    bottom: 24,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(32),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const DefaultAvatar(size: 44),
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
                                        icon: const Icon(
                                          Icons.notifications_none_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                _buildReportContent(
                                  generus: generusSnapshot.data!,
                                  kelas: kelasSnapshot.data!,
                                  materi: materiSnapshot.data!,
                                  pertemuan: pertemuanSnapshot.data!,
                                  prestasi: prestasiSnapshot.data!,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
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
