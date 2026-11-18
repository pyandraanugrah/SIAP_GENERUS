
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class KelasListScreen extends StatefulWidget {
  const KelasListScreen({super.key});

  @override
  State<KelasListScreen> createState() => _KelasListScreenState();
}

class _KelasListScreenState extends State<KelasListScreen> {
  final FirestoreService _firestore = FirestoreService.instance;

  String _selectedLevel = 'Semua';

  final List<String> _levels = [
    'Semua',
    'PAUD',
    'SD',
    'SMP',
    'SMA',
  ];

  // ================= TAMBAH DAN EDIT KELAS =================

  Future<void> _showKelasForm({KelasModel? kelas}) async {
    final result = await showDialog<KelasModel>(
      context: context,
      builder: (_) => _KelasFormDialog(kelas: kelas),
    );

    if (result == null || !mounted) return;

    try {
      if (kelas == null) {
        await _firestore.addKelas(result);
      } else {
        await _firestore.updateKelas(result);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kelas == null
                ? 'Kelas berhasil ditambahkan'
                : 'Kelas berhasil diperbarui',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan kelas: $e'),
        ),
      );
    }
  }

  // ================= HAPUS KELAS =================

  Future<void> _deleteKelas(KelasModel kelas) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Kelas'),
          content: Text(
            'Yakin ingin menghapus kelas ${kelas.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    try {
      await _firestore.deleteKelas(kelas.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kelas berhasil dihapus'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus kelas: $e'),
        ),
      );
    }
  }

  // ================= DETAIL KELAS =================

  void _showKelasDetail(
    KelasModel kelas,
    List<GenerusModel> allGenerus,
  ) {
    final relatedGenerus = allGenerus.where((g) {
      return g.kelas.trim().toLowerCase() ==
          kelas.name.trim().toLowerCase();
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kelas.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jenjang: ${kelas.level}',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pengajar Utama: ${kelas.teacherName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 28),
                Text(
                  'Generus Terdaftar (${relatedGenerus.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                if (relatedGenerus.isEmpty)
                  const Text(
                    'Belum ada Generus yang terdaftar di kelas ini.',
                  )
                else
                  ...relatedGenerus.map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${g.name} (NISN: ${g.nisn})',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _showKelasForm(kelas: kelas);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _deleteKelas(kelas);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= TAMPILAN UTAMA =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Data Kelas'),
        actions: [
          IconButton(
            onPressed: () => _showKelasForm(),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Kelas',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showKelasForm(),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kelas'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _levels.map((level) {
                  final isSelected = _selectedLevel == level;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: isSelected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedLevel = level;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<KelasModel>>(
              stream: _firestore.watchKelas(),
              builder: (context, kelasSnapshot) {
                if (kelasSnapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat data kelas:\n${kelasSnapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (kelasSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allKelas = kelasSnapshot.data ?? [];

                final filteredKelas = _selectedLevel == 'Semua'
                    ? allKelas
                    : allKelas
                        .where((k) => k.level == _selectedLevel)
                        .toList();

                if (filteredKelas.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data kelas. Tambahkan kelas baru.',
                    ),
                  );
                }

                return StreamBuilder<List<GenerusModel>>(
                  stream: _firestore.watchGenerus(),
                  builder: (context, generusSnapshot) {
                    final allGenerus = generusSnapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        90,
                      ),
                      itemCount: filteredKelas.length,
                      itemBuilder: (context, index) {
                        final kelas = filteredKelas[index];

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
                                child: Icon(
                                  Icons.school_rounded,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                            title: Text(
                              kelas.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Jenjang: ${kelas.level}\n'
                              'Pengajar: ${kelas.teacherName}\n'
                              'Jumlah: ${kelas.studentCount} Generus',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                            ),
                            onTap: () {
                              _showKelasDetail(
                                kelas,
                                allGenerus,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// FORM KELAS TERPISAH DARI HALAMAN UTAMA
// ======================================================

class _KelasFormDialog extends StatefulWidget {
  final KelasModel? kelas;

  const _KelasFormDialog({
    this.kelas,
  });

  @override
  State<_KelasFormDialog> createState() =>
      _KelasFormDialogState();
}

class _KelasFormDialogState extends State<_KelasFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _teacherController;

  late String _selectedLevel;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.kelas?.name ?? '',
    );

    _teacherController = TextEditingController(
      text: widget.kelas?.teacherName ?? '',
    );

    const levels = ['PAUD', 'SD', 'SMP', 'SMA'];

    final existingLevel = widget.kelas?.level ?? 'SD';

    _selectedLevel = levels.contains(existingLevel)
        ? existingLevel
        : 'SD';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = KelasModel(
      id: widget.kelas?.id ?? '',
      name: _nameController.text.trim(),
      level: _selectedLevel,
      teacherName: _teacherController.text.trim(),
      studentCount: widget.kelas?.studentCount ?? 0,
    );

    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.kelas == null ? 'Tambah Kelas' : 'Edit Kelas',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kelas',
                  hintText: 'Contoh: Kelas Al-Quran 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kelas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Jenjang',
                  border: OutlineInputBorder(),
                ),
                items: const ['PAUD', 'SD', 'SMP', 'SMA']
                    .map(
                      (level) => DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLevel = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pengajar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama pengajar wajib diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
