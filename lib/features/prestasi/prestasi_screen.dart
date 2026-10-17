import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class PrestasiScreen extends StatefulWidget {
  const PrestasiScreen({super.key});

  @override
  State<PrestasiScreen> createState() => _PrestasiScreenState();
}

class _PrestasiScreenState extends State<PrestasiScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  String _selectedLevel = 'Semua';
  final List<String> _levels = ['Semua', 'Kecamatan', 'Kabupaten', 'Provinsi', 'Nasional'];

  @override
  void initState() {
    super.initState();
    _dataStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _dataStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<PrestasiModel> get _filteredPrestasi {
    if (_selectedLevel == 'Semua') {
      return _dataStore.prestasiList;
    }
    return _dataStore.prestasiList.where((p) => p.level == _selectedLevel).toList();
  }

  void _showAddPrestasiDialog() {
    final nameCtrl = TextEditingController(text: 'Muhammad Dimaz Albintani');
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Oktober 2026');
    final docCtrl = TextEditingController(text: 'Sertifikat & Medali');
    String category = 'Tahfidz';
    String level = 'Kecamatan';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Catat Prestasi Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Generus'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Nama / Judul Prestasi & Kejuaraan'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(labelText: 'Bidang'),
                          items: ['Tahfidz', 'Tilawah', 'Akademik', 'Seni', 'Olahraga']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setMState(() => category = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: level,
                          decoration: const InputDecoration(labelText: 'Tingkat'),
                          items: ['Kecamatan', 'Kabupaten', 'Provinsi', 'Nasional']
                              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                              .toList(),
                          onChanged: (v) => setMState(() => level = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(labelText: 'Waktu / Periode'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: docCtrl,
                    decoration: const InputDecoration(labelText: 'Keterangan Dokumentasi / Piagam'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final newPr = PrestasiModel(
                            id: 'PR${DateTime.now().millisecondsSinceEpoch}',
                            generusName: nameCtrl.text.trim(),
                            title: titleCtrl.text.trim(),
                            category: category,
                            level: level,
                            date: dateCtrl.text.trim(),
                            documentation: docCtrl.text.trim(),
                          );
                          _dataStore.addPrestasi(newPr);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Prestasi berhasil ditambahkan!')),
                          );
                        }
                      },
                      child: const Text('Simpan Prestasi'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredPrestasi;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Prestasi Generus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Prestasi',
            onPressed: () => _showAddPrestasiDialog(),
          ),
        ],
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
            child: list.isEmpty
                ? const Center(child: Text('Tidak ada data prestasi pada filter ini'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF9E6),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFFFE082)),
                                ),
                                child: const Center(
                                  child: Icon(Icons.emoji_events_rounded, color: AppColors.accentGold, size: 28),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
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
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryGreen,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Tk. ${item.level}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Peraih: ${item.generusName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Waktu: ${item.date} • Dok: ${item.documentation}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
