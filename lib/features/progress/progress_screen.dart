import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DummyDataStore.instance;

    int overallProgress = ((store.tilawahProgress +
                store.hafalanProgress +
                store.doaProgress +
                store.pegonProgress) /
            4)
        .round();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Progres Belajar Generus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Card Context
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.lightGreenBadge,
                    child: Icon(Icons.school_rounded, color: AppColors.primaryGreen, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${store.studentKelas} • NISN: ${store.studentNisn}',
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Overall Progress Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: overallProgress / 100,
                          strokeWidth: 7,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        Text(
                          '$overallProgress%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progres Keseluruhan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Akumulasi capaian Tilawah, Doa, Hafalan, dan Pegon semester ini.',
                          style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Rincian Capaian Materi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
            ),

            const SizedBox(height: 12),

            _buildCategoryProgressCard(
              title: 'Progress Tilawah',
              category: 'Tilawah',
              percent: store.tilawahProgress,
              note: 'Makhraj huruf hijaiyah dan hukum tajwid nun sukun.',
              icon: Icons.auto_stories_rounded,
            ),
            const SizedBox(height: 12),
            _buildCategoryProgressCard(
              title: 'Progress Hafalan',
              category: 'Hafalan',
              percent: store.hafalanProgress,
              note: 'Surat-surat pendek juz 30, Al-Mulk, dan Ar-Rahman.',
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: 12),
            _buildCategoryProgressCard(
              title: 'Progress Doa',
              category: 'Doa',
              percent: store.doaProgress,
              note: 'Doa sebelum belajar, sesudah belajar, dan adab yaumiyah.',
              icon: Icons.volunteer_activism_rounded,
            ),
            const SizedBox(height: 12),
            _buildCategoryProgressCard(
              title: 'Progress Pegon',
              category: 'Pegon',
              percent: store.pegonProgress,
              note: 'Dasar membaca dan menulis abjad Arab-Melayu/Pegon.',
              icon: Icons.edit_note_rounded,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProgressCard({
    required String title,
    required String category,
    required int percent,
    required String note,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primaryGreen, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ],
              ),
              Text(
                '$percent%',
                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5EDE8),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}
