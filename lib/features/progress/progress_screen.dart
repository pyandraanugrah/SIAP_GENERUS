
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final FirestoreService _firestore = FirestoreService.instance;

  String? _selectedGenerusId;

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Progress Tilawah',
      'category': 'Tilawah',
      'note': 'Makhraj huruf hijaiyah dan hukum tajwid nun sukun.',
      'icon': Icons.auto_stories_rounded,
    },
    {
      'title': 'Progress Hafalan',
      'category': 'Hafalan',
      'note': 'Surat-surat pendek juz 30, Al-Mulk, dan Ar-Rahman.',
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Progress Doa',
      'category': 'Doa',
      'note': 'Doa sebelum belajar, sesudah belajar, dan adab yaumiyah.',
      'icon': Icons.volunteer_activism_rounded,
    },
    {
      'title': 'Progress Pegon',
      'category': 'Pegon',
      'note': 'Dasar membaca dan menulis abjad Arab-Melayu/Pegon.',
      'icon': Icons.edit_note_rounded,
    },
  ];

  Future<void> _editProgress({
    required GenerusModel generus,
    required String category,
    required int currentProgress,
  }) async {
    double selectedProgress = currentProgress.toDouble();

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ubah Progres $category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${selectedProgress.round()}%',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Slider(
                    value: selectedProgress,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${selectedProgress.round()}%',
                    activeColor: AppColors.primaryGreen,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedProgress = value;
                      });
                    },
                  ),
                  const Text(
                    'Geser untuk mengatur persentase capaian belajar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      selectedProgress.round(),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    try {
      await _firestore.updateProgressBelajar(
        generusId: generus.id,
        generusName: generus.name,
        category: category,
        progress: result,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progres $category berhasil disimpan.'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan progres: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Progres Belajar Generus'),
      ),
      body: StreamBuilder<List<GenerusModel>>(
        stream: _firestore.watchGenerus(),
        builder: (context, generusSnapshot) {
          if (generusSnapshot.hasError) {
            return _buildMessage(
              'Gagal memuat data Generus.\n${generusSnapshot.error}',
            );
          }

          if (generusSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final generusList = generusSnapshot.data ?? [];

          if (generusList.isEmpty) {
            return _buildMessage(
              'Belum ada data Generus. Tambahkan Generus terlebih dahulu.',
            );
          }

          final selectedGenerus = generusList.firstWhere(
            (item) => item.id == _selectedGenerusId,
            orElse: () => generusList.first,
          );

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.watchProgressForGenerus(
              selectedGenerus.id,
            ),
            builder: (context, progressSnapshot) {
              if (progressSnapshot.hasError) {
                return _buildMessage(
                  'Gagal memuat progres belajar.\n${progressSnapshot.error}',
                );
              }

              if (progressSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final progressData = progressSnapshot.data ?? [];

              final Map<String, int> progressMap = {
                'Tilawah': 0,
                'Hafalan': 0,
                'Doa': 0,
                'Pegon': 0,
              };

              for (final item in progressData) {
                final category = item['category'] as String? ?? '';
                final value = (item['progress'] as num?)?.toInt() ?? 0;

                if (progressMap.containsKey(category)) {
                  progressMap[category] = value.clamp(0, 100);
                }
              }

              final overallProgress = (
                progressMap.values.reduce((a, b) => a + b) /
                progressMap.length
              ).round();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentCard(
                      generusList,
                      selectedGenerus,
                    ),
                    const SizedBox(height: 18),
                    _buildOverallProgress(overallProgress),
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
                    ..._categories.map((item) {
                      final category = item['category'] as String;
                      final percent = progressMap[category] ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCategoryProgressCard(
                          title: item['title'] as String,
                          category: category,
                          percent: percent,
                          note: item['note'] as String,
                          icon: item['icon'] as IconData,
                          onTap: () => _editProgress(
                            generus: selectedGenerus,
                            category: category,
                            currentProgress: percent,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Tekan salah satu kategori untuk mengubah progres.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(
    List<GenerusModel> generusList,
    GenerusModel selectedGenerus,
  ) {
    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.lightGreenBadge,
                child: Icon(
                  Icons.school_rounded,
                  color: AppColors.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedGenerus.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${selectedGenerus.kelas} • NISN: ${selectedGenerus.nisn}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedGenerus.id,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Pilih Generus',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: generusList.map((generus) {
              return DropdownMenuItem<String>(
                value: generus.id,
                child: Text(
                  generus.name,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedGenerusId = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(int overallProgress) {
    return Container(
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
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
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
                  'Akumulasi capaian Tilawah, Doa, Hafalan, dan Pegon.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgressCard({
    required String title,
    required String category,
    required int percent,
    required String note,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: AppColors.primaryGreen,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              note,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
