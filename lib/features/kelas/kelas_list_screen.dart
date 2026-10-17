import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class KelasListScreen extends StatefulWidget {
  const KelasListScreen({super.key});

  @override
  State<KelasListScreen> createState() => _KelasListScreenState();
}

class _KelasListScreenState extends State<KelasListScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  String _selectedLevel = 'Semua';
  final List<String> _levels = ['Semua', 'PAUD', 'SD', 'SMP', 'SMA'];

  List<KelasModel> get _filteredKelas {
    if (_selectedLevel == 'Semua') {
      return _dataStore.kelasList;
    }
    return _dataStore.kelasList.where((k) => k.level == _selectedLevel).toList();
  }

  void _showKelasDetail(KelasModel k) {
    final relatedGenerus = _dataStore.generusList
        .where((g) => g.kelas.toLowerCase().contains(k.name.toLowerCase()) || g.level == k.level)
        .toList();

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
            Text(k.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('Jenjang: ${k.level} • Kapasitas: ${k.studentCount} Generus', style: const TextStyle(color: AppColors.secondaryText)),
            Text('Pengajar Utama: ${k.teacherName}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const Divider(height: 24),
            const Text('Generus Terdaftar (Sampel):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            if (relatedGenerus.isEmpty)
              const Text('Belum ada generus terdaftar pada filter ini.')
            else
              ...relatedGenerus.take(4).map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primaryGreen),
                          const SizedBox(width: 8),
                          Text('${g.name} (NISN: ${g.nisn})'),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredKelas;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Data Kelas'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _levels.map((lvl) {
                  final isSel = _selectedLevel == lvl;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(lvl),
                      selected: isSel,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedLevel = lvl),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final k = list[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreenBadge,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.school_rounded, color: AppColors.primaryGreen),
                      ),
                    ),
                    title: Text(k.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Pengajar: ${k.teacherName}\nJumlah: ${k.studentCount} Generus'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showKelasDetail(k),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
