import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class GenerusListScreen extends StatefulWidget {
  const GenerusListScreen({super.key});

  @override
  State<GenerusListScreen> createState() => _GenerusListScreenState();
}

class _GenerusListScreenState extends State<GenerusListScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  final TextEditingController _searchCtrl = TextEditingController();

  String _selectedLevel = 'Semua';
  String _searchQuery = '';
  final List<String> _levels = ['Semua', 'PAUD', 'SD', 'SMP', 'SMA'];

  @override
  void initState() {
    super.initState();
    _dataStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _dataStore.removeListener(_refresh);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<GenerusModel> get _filteredGenerus {
    return _dataStore.generusList.where((g) {
      final matchesLevel = _selectedLevel == 'Semua' || g.level == _selectedLevel;
      final matchesQuery = _searchQuery.isEmpty ||
          g.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          g.nisn.contains(_searchQuery) ||
          g.kelas.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesLevel && matchesQuery;
    }).toList();
  }

  void _showGenerusForm([GenerusModel? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final nisnCtrl = TextEditingController(text: existing?.nisn ?? '');
    final kelasCtrl = TextEditingController(text: existing?.kelas ?? '5 SD');
    final parentNameCtrl = TextEditingController(text: existing?.parentName ?? '');
    final parentPhoneCtrl = TextEditingController(text: existing?.parentPhone ?? '');
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    String level = existing?.level ?? 'SD';
    String gender = existing?.gender ?? 'Laki-laki';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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
                      Text(
                        existing == null ? 'Tambah Generus Baru' : 'Edit Data Generus',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nisnCtrl,
                          decoration: const InputDecoration(labelText: 'NISN'),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: kelasCtrl,
                          decoration: const InputDecoration(labelText: 'Kelas (mis. 5 SD)'),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: level,
                          decoration: const InputDecoration(labelText: 'Jenjang'),
                          items: ['PAUD', 'SD', 'SMP', 'SMA']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setMState(() => level = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: gender,
                          decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                          items: ['Laki-laki', 'Perempuan']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setMState(() => gender = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Data Orang Tua / Wali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: parentNameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Orang Tua'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: parentPhoneCtrl,
                    decoration: const InputDecoration(labelText: 'No. WhatsApp / HP Orang Tua'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(labelText: 'Alamat Domisili'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (existing == null) {
                            final newItem = GenerusModel(
                              id: 'G${DateTime.now().millisecondsSinceEpoch}',
                              name: nameCtrl.text.trim(),
                              nisn: nisnCtrl.text.trim(),
                              kelas: kelasCtrl.text.trim(),
                              level: level,
                              gender: gender,
                              parentName: parentNameCtrl.text.trim(),
                              parentPhone: parentPhoneCtrl.text.trim(),
                              address: addressCtrl.text.trim().isEmpty ? 'Surabaya' : addressCtrl.text.trim(),
                            );
                            _dataStore.addGenerus(newItem);
                          } else {
                            final updated = existing.copyWith(
                              name: nameCtrl.text.trim(),
                              nisn: nisnCtrl.text.trim(),
                              kelas: kelasCtrl.text.trim(),
                              level: level,
                              gender: gender,
                              parentName: parentNameCtrl.text.trim(),
                              parentPhone: parentPhoneCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
                            );
                            _dataStore.updateGenerus(updated);
                          }
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(existing == null ? 'Generus ditambahkan!' : 'Data berhasil diperbarui!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text(existing == null ? 'Simpan Generus' : 'Perbarui Data'),
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

  void _showGenerusDetail(GenerusModel g) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(g.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showGenerusForm(g);
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('NISN: ${g.nisn} • Kelas: ${g.kelas} (${g.level})', style: const TextStyle(color: AppColors.secondaryText)),
            Text('Jenis Kelamin: ${g.gender}', style: const TextStyle(color: AppColors.secondaryText)),
            const Divider(height: 24),
            const Text('Data Orang Tua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Text('Nama: ${g.parentName}'),
            Text('Kontak: ${g.parentPhone}'),
            Text('Alamat: ${g.address}'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredGenerus;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Data Generus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Tambah Generus',
            onPressed: () => _showGenerusForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: const InputDecoration(
                    hintText: 'Cari nama, NISN, atau kelas...',
                    prefixIcon: Icon(Icons.search, color: AppColors.primaryGreen),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _levels.map((lvl) {
                      final sel = _selectedLevel == lvl;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(lvl),
                          selected: sel,
                          selectedColor: AppColors.primaryGreen,
                          labelStyle: TextStyle(
                            color: sel ? Colors.white : AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) => setState(() => _selectedLevel = lvl),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('Tidak ada data generus'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.lightGreenBadge,
                            child: Text(
                              item.name.isNotEmpty ? item.name[0] : 'G',
                              style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('NISN: ${item.nisn} • ${item.kelas} • Wali: ${item.parentName}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showGenerusDetail(item),
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
