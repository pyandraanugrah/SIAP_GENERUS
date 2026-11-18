
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class PembinaanScreen extends StatefulWidget {
  const PembinaanScreen({super.key});

  @override
  State<PembinaanScreen> createState() => _PembinaanScreenState();
}

class _PembinaanScreenState extends State<PembinaanScreen> {
  final FirestoreService _service = FirestoreService.instance;

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showAddPembinaanDialog([
    PembinaanModel? existing,
  ]) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (ctx) {
        return _PembinaanFormSheet(
          existing: existing,
          service: _service,
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      _showMessage('Catatan pembinaan berhasil disimpan!');
    }
  }

  Future<void> _deletePembinaan(PembinaanModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text(
          'Hapus catatan pembinaan untuk ${item.generusName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    try {
      await _service.deletePembinaan(item.id);

      _showMessage('Catatan pembinaan berhasil dihapus.');
    } catch (e) {
      _showMessage('Gagal menghapus catatan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Pembinaan Generus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            tooltip: 'Tambah Catatan',
            onPressed: () => _showAddPembinaanDialog(),
          ),
        ],
      ),
      body: StreamBuilder<List<PembinaanModel>>(
        stream: _service.watchPembinaan(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Gagal memuat data pembinaan. '
                  'Periksa koneksi internet dan Firestore Rules.',
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

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(
              child: Text('Belum ada catatan pembinaan.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              final isDone = item.status == 'Selesai';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDone
                                    ? AppColors.secondaryGreen
                                    : const Color(0xFFE65100),
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showAddPembinaanDialog(item);
                              } else if (value == 'delete') {
                                _deletePembinaan(item);
                              }
                            },
                            itemBuilder: (ctx) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.generusName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tanggal: ${item.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Catatan: ${item.notes}',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAF9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFE8EDE9),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Tindak Lanjut: ${item.followupAction}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
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
    );
  }
}

// FORM PEMBINAAN
// Controller dikelola oleh State widget ini.

class _PembinaanFormSheet extends StatefulWidget {
  final PembinaanModel? existing;
  final FirestoreService service;

  const _PembinaanFormSheet({
    this.existing,
    required this.service,
  });

  @override
  State<_PembinaanFormSheet> createState() =>
      _PembinaanFormSheetState();
}

class _PembinaanFormSheetState
    extends State<_PembinaanFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _followupCtrl;

  late String _category;
  late String _status;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _nameCtrl = TextEditingController(
      text: existing?.generusName ?? '',
    );

    _dateCtrl = TextEditingController(
      text: existing?.date ?? '',
    );

    _notesCtrl = TextEditingController(
      text: existing?.notes ?? '',
    );

    _followupCtrl = TextEditingController(
      text: existing?.followupAction ?? '',
    );

    _category = existing?.category ?? 'Akhlak';
    _status = existing?.status ?? 'Dalam Proses';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _notesCtrl.dispose();
    _followupCtrl.dispose();

    super.dispose();
  }

  Future<void> _savePembinaan() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final existing = widget.existing;

    final pembinaan = PembinaanModel(
      id: existing?.id ?? '',
      generusName: _nameCtrl.text.trim(),
      date: _dateCtrl.text.trim(),
      category: _category,
      notes: _notesCtrl.text.trim(),
      followupAction: _followupCtrl.text.trim(),
      status: _status,
    );

    try {
      if (existing == null) {
        await widget.service.addPembinaan(pembinaan);
      } else {
        await widget.service.updatePembinaan(pembinaan);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan catatan: $e'),
        ),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Padding(
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
                    isEditing
                        ? 'Edit Catatan'
                        : 'Catatan Pembinaan Baru',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Generus',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Wajib diisi'
                        : null,
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Pembinaan',
                      ),
                      items: [
                        'Akhlak',
                        'Kedisiplinan',
                        'Motivasi',
                        'Ibadah',
                      ].map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        );
                      }).toList(),
                      onChanged: _isSaving
                          ? null
                          : (v) {
                              if (v != null) {
                                setState(() {
                                  _category = v;
                                });
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status Tindak Lanjut',
                      ),
                      items: [
                        'Dalam Proses',
                        'Selesai',
                      ].map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        );
                      }).toList(),
                      onChanged: _isSaving
                          ? null
                          : (v) {
                              if (v != null) {
                                setState(() {
                                  _status = v;
                                });
                              }
                            },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Catatan',
                  hintText: 'Contoh: 18 Nov 2026',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Wajib diisi'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan Perkembangan / Masalah',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Wajib diisi'
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _followupCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Rencana Tindak Lanjut',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Wajib diisi'
                        : null,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePembinaan,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? 'Perbarui' : 'Simpan',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
