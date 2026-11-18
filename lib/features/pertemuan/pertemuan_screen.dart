
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';
import '../../shared/widgets/default_avatar.dart';
import '../absensi/absensi_screen.dart';

class PertemuanScreen extends StatefulWidget {
  const PertemuanScreen({super.key});

  @override
  State<PertemuanScreen> createState() => _PertemuanScreenState();
}

class _PertemuanScreenState extends State<PertemuanScreen> {
  final FirestoreService _firestore = FirestoreService.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  final List<String> _filters = [
    'Semua',
    'Akan Datang',
    'Selesai',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PertemuanModel> _filterPertemuan(List<PertemuanModel> data) {
    return data.where((p) {
      final matchesFilter =
          _selectedFilter == 'Semua' || p.status == _selectedFilter;

      final query = _searchQuery.toLowerCase();

      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query);

      return matchesFilter && matchesQuery;
    }).toList();
  }

  // ================= TAMBAH PERTEMUAN =================

  Future<void> _showAddPertemuanDialog() async {
    final result = await showModalBottomSheet<PertemuanModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _PertemuanFormSheet(),
    );

    if (!mounted || result == null) return;

    try {
      await _firestore.addPertemuan(result);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pertemuan berhasil disimpan ke Firebase!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan pertemuan: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ================= HAPUS PERTEMUAN =================

  Future<void> _confirmDeletePertemuan(PertemuanModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Pertemuan?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus pertemuan "${item.title}"? '
            'Data yang sudah dihapus tidak dapat ditampilkan kembali.',
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
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _firestore.deletePertemuan(item.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pertemuan berhasil dihapus.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus pertemuan: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ================= DETAIL PERTEMUAN =================

  void _showDetailPertemuan(PertemuanModel p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
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
                        color: p.status == 'Akan Datang'
                            ? AppColors.lightGreenBadge
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        p.status,
                        style: TextStyle(
                          color: p.status == 'Akan Datang'
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText,
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
                  p.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 14),
                _detailRow(Icons.calendar_month_outlined, p.date),
                const SizedBox(height: 8),
                _detailRow(Icons.access_time_rounded, p.time),
                const SizedBox(height: 8),
                _detailRow(Icons.place_outlined, p.location),
                const SizedBox(height: 14),
                Text(
                  p.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.how_to_reg_rounded),
                    label: const Text('Buka Presensi Pertemuan Ini'),
                    onPressed: () {
                      Navigator.pop(ctx);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AbsensiScreen(
                            preselectedMeetingId: p.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  // ================= KARTU PERTEMUAN =================

  Widget _buildMeetingCard(PertemuanModel item) {
    return GestureDetector(
      onTap: () => _showDetailPertemuan(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: item.status == 'Akan Datang'
                        ? AppColors.lightGreenBadge
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: item.status == 'Akan Datang'
                          ? AppColors.primaryGreen
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  tooltip: 'Pilihan pertemuan',
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.secondaryText,
                  ),
                  onSelected: (value) {
                    if (value == 'hapus') {
                      _confirmDeletePertemuan(item);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'hapus',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hapus Pertemuan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
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
  }

  // ================= TAMPILAN UTAMA =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Column(
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'Pertemuan',
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
                const SizedBox(height: 18),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.trim();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // FILTER DAN TOMBOL BUAT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final selected = _selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryGreen
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primaryGreen
                                      : const Color(0xFF1B1B1B),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF1B1B1B),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showAddPertemuanDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Buat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DATA FIRESTORE
          Expanded(
            child: StreamBuilder<List<PertemuanModel>>(
              stream: _firestore.watchPertemuan(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Gagal memuat pertemuan. Periksa koneksi dan aturan Firestore.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                final list = _filterPertemuan(snapshot.data ?? []);

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada jadwal pertemuan yang sesuai',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

                    final showHeader = index == 0 ||
                        list[index - 1].status != item.status;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 4,
                            ),
                            child: Text(
                              item.status,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        _buildMeetingCard(item),
                      ],
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
// FORM PERTEMUAN TERPISAH
// ======================================================

class _PertemuanFormSheet extends StatefulWidget {
  const _PertemuanFormSheet();

  @override
  State<_PertemuanFormSheet> createState() =>
      _PertemuanFormSheetState();
}

class _PertemuanFormSheetState extends State<_PertemuanFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _status = 'Akan Datang';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _locCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _savePertemuan() {
    if (!_formKey.currentState!.validate()) return;

    final pertemuan = PertemuanModel(
      id: '',
      title: _titleCtrl.text.trim(),
      date: _dateCtrl.text.trim(),
      time: _timeCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      status: _status,
      description: _descCtrl.text.trim().isEmpty
          ? 'Pembinaan generus terarah.'
          : _descCtrl.text.trim(),
    );

    Navigator.pop(context, pertemuan);
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'Buat Pertemuan Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama / Judul Pertemuan',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal',
                        hintText: 'Contoh: Senin, 02 Nov 2026',
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _timeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Waktu',
                        hintText: '18:30 - 20:00 WIB',
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tempat / Lokasi',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status Pertemuan',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Akan Datang',
                    child: Text('Akan Datang'),
                  ),
                  DropdownMenuItem(
                    value: 'Selesai',
                    child: Text('Selesai'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Singkat',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _savePertemuan,
                  child: const Text('Simpan Pertemuan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
