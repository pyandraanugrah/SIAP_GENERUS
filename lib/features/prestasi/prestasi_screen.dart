
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class PrestasiScreen extends StatefulWidget {
  const PrestasiScreen({super.key});

  @override
  State<PrestasiScreen> createState() => _PrestasiScreenState();
}

class _PrestasiScreenState extends State<PrestasiScreen> {
  final FirestoreService _firestore = FirestoreService.instance;

  String _selectedLevel = 'Semua';

  final List<String> _levels = [
    'Semua',
    'Kecamatan',
    'Kabupaten',
    'Provinsi',
    'Nasional',
  ];

  Future<void> _showPrestasiForm({PrestasiModel? prestasi}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrestasiFormSheet(prestasi: prestasi),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            prestasi == null
                ? 'Prestasi berhasil ditambahkan!'
                : 'Prestasi berhasil diperbarui!',
          ),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }

  Future<void> _deletePrestasi(PrestasiModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Prestasi'),
        content: Text(
          'Yakin ingin menghapus prestasi "${item.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _firestore.deletePrestasi(item.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prestasi berhasil dihapus.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus prestasi: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Prestasi Generus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Prestasi',
            onPressed: () => _showPrestasiForm(),
          ),
        ],
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
            child: StreamBuilder<List<PrestasiModel>>(
              stream: _firestore.watchPrestasi(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat data prestasi:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allPrestasi = snapshot.data ?? [];

                final list = _selectedLevel == 'Semua'
                    ? allPrestasi
                    : allPrestasi
                        .where((item) => item.level == _selectedLevel)
                        .toList();

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada data prestasi pada filter ini',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

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
                                border: Border.all(
                                  color: const Color(0xFFFFE082),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.emoji_events_rounded,
                                  color: AppColors.accentGold,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 5,
                                          children: [
                                            _buildBadge(
                                              item.category,
                                              AppColors.lightGreenBadge,
                                              AppColors.primaryGreen,
                                            ),
                                            _buildBadge(
                                              'Tk. ${item.level}',
                                              Colors.grey.shade200,
                                              AppColors.primaryText,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showPrestasiForm(
                                              prestasi: item,
                                            );
                                          } else if (value == 'delete') {
                                            _deletePrestasi(item);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined),
                                                SizedBox(width: 8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildBadge(
    String text,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

// ==================== FORM PRESTASI ====================

class _PrestasiFormSheet extends StatefulWidget {
  final PrestasiModel? prestasi;

  const _PrestasiFormSheet({this.prestasi});

  @override
  State<_PrestasiFormSheet> createState() =>
      _PrestasiFormSheetState();
}

class _PrestasiFormSheetState extends State<_PrestasiFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirestoreService.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _documentationController;

  String _category = 'Tahfidz';
  String _level = 'Kecamatan';
  bool _saving = false;

  final List<String> _categories = [
    'Tahfidz',
    'Tilawah',
    'Akademik',
    'Seni',
    'Olahraga',
  ];

  final List<String> _levels = [
    'Kecamatan',
    'Kabupaten',
    'Provinsi',
    'Nasional',
  ];

  @override
  void initState() {
    super.initState();

    final item = widget.prestasi;

    _nameController = TextEditingController(
      text: item?.generusName ?? '',
    );
    _titleController = TextEditingController(
      text: item?.title ?? '',
    );
    _dateController = TextEditingController(
      text: item?.date ?? '',
    );
    _documentationController = TextEditingController(
      text: item?.documentation ?? '',
    );

    if (item != null) {
      _category = _categories.contains(item.category)
          ? item.category
          : 'Tahfidz';

      _level = _levels.contains(item.level)
          ? item.level
          : 'Kecamatan';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _documentationController.dispose();
    super.dispose();
  }

  Future<void> _savePrestasi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final item = PrestasiModel(
        id: widget.prestasi?.id ?? '',
        generusName: _nameController.text.trim(),
        title: _titleController.text.trim(),
        category: _category,
        level: _level,
        date: _dateController.text.trim(),
        documentation: _documentationController.text.trim(),
      );

      if (widget.prestasi == null) {
        await _firestore.addPrestasi(item);
      } else {
        await _firestore.updatePrestasi(item);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan prestasi: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.prestasi == null
                          ? 'Catat Prestasi Baru'
                          : 'Edit Prestasi',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Generus',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama Generus wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Nama / Judul Prestasi & Kejuaraan',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul prestasi wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Bidang',
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _level,
                        decoration: const InputDecoration(
                          labelText: 'Tingkat',
                        ),
                        items: _levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _level = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Waktu / Periode',
                    hintText: 'Contoh: Oktober 2026',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _documentationController,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan Dokumentasi / Piagam',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _savePrestasi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.prestasi == null
                                ? 'Simpan Prestasi'
                                : 'Simpan Perubahan',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
