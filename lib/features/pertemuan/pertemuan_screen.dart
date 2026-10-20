import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';
import '../absensi/absensi_screen.dart';
import '../../shared/widgets/default_avatar.dart';

class PertemuanScreen extends StatefulWidget {
  const PertemuanScreen({super.key});

  @override
  State<PertemuanScreen> createState() => _PertemuanScreenState();
}

class _PertemuanScreenState extends State<PertemuanScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  final List<String> _filters = ['Semua', 'Akan Datang', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _dataStore.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataStore.removeListener(_onDataChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  List<PertemuanModel> get _filteredPertemuan {
    return _dataStore.pertemuanList.where((p) {
      final matchesFilter =
          _selectedFilter == 'Semua' || p.status == _selectedFilter;
      final matchesQuery =
          _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();
  }

  void _showAddPertemuanDialog() {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Senin, 02 Nov 2026');
    final timeCtrl = TextEditingController(text: '18:30 - 20:00 WIB');
    final locCtrl = TextEditingController(text: 'Masjid Baitul Makmur');
    final descCtrl = TextEditingController();
    String status = 'Akan Datang';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
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
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama / Judul Pertemuan',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dateCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Tanggal',
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: timeCtrl,
                          decoration: const InputDecoration(labelText: 'Waktu'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: locCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tempat / Lokasi',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: status,
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
                    onChanged: (v) => setModalState(() => status = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descCtrl,
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final newP = PertemuanModel(
                            id: 'P${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            date: dateCtrl.text.trim(),
                            time: timeCtrl.text.trim(),
                            location: locCtrl.text.trim(),
                            status: status,
                            description: descCtrl.text.trim().isEmpty
                                ? 'Pembinaan generus terarah.'
                                : descCtrl.text.trim(),
                          );
                          _dataStore.addPertemuan(newP);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pertemuan berhasil disimpan secara lokal!',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text('Simpan Pertemuan'),
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

  void _showDetailPertemuan(PertemuanModel p) {
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
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  p.date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  p.time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    p.location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
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
                      builder: (_) => AbsensiScreen(preselectedMeetingId: p.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredPertemuan;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Column(
        children: [
          // Header curved container
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

                // Search Bar
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
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
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

          // Horizontal Filter Chips & Add Meeting Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((fil) {
                        final isSelected = _selectedFilter == fil;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilter = fil),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryGreen
                                      : const Color(0xFF1B1B1B),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                fil,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
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

          // List of Pertemuan
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada jadwal pertemuan yang sesuai',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      final item = list[index];
                      // Show section header when status changes or on the first item
                      final bool showHeader =
                          index == 0 || list[index - 1].status != item.status;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader) ...[
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
                          ],
                          GestureDetector(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: AppColors.secondaryText,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryText,
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
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
