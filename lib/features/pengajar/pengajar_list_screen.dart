import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class PengajarListScreen extends StatefulWidget {
  const PengajarListScreen({super.key});

  @override
  State<PengajarListScreen> createState() => _PengajarListScreenState();
}

class _PengajarListScreenState extends State<PengajarListScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

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

  List<PengajarModel> get _filteredPengajar {
    return _dataStore.pengajarList.where((p) {
      return _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.subject.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showPengajarForm([PengajarModel? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final roleCtrl = TextEditingController(text: existing?.role ?? 'Pengajar');
    final subjectCtrl = TextEditingController(text: existing?.subject ?? '');
    final classesCtrl = TextEditingController(text: existing?.classes.join(', ') ?? '5 SD, 6 SD');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '081234567890');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
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
                      existing == null ? 'Tambah Pengajar' : 'Edit Pengajar',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: roleCtrl,
                  decoration: const InputDecoration(labelText: 'Peran / Jabatan'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(labelText: 'Bidang Pembinaan / Mata Pelajaran'),
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: classesCtrl,
                  decoration: const InputDecoration(labelText: 'Kelas yang Diampu (pisahkan koma)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Nomor Kontak'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final splitClasses = classesCtrl.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        if (existing == null) {
                          final newT = PengajarModel(
                            id: 'T${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            role: roleCtrl.text.trim(),
                            subject: subjectCtrl.text.trim(),
                            classes: splitClasses.isEmpty ? ['5 SD'] : splitClasses,
                            phone: phoneCtrl.text.trim(),
                          );
                          _dataStore.addPengajar(newT);
                        } else {
                          final updated = existing.copyWith(
                            name: nameCtrl.text.trim(),
                            role: roleCtrl.text.trim(),
                            subject: subjectCtrl.text.trim(),
                            classes: splitClasses,
                            phone: phoneCtrl.text.trim(),
                          );
                          _dataStore.updatePengajar(updated);
                        }
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(existing == null ? 'Pengajar ditambahkan!' : 'Data pengajar diperbarui!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Text(existing == null ? 'Simpan' : 'Perbarui'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPengajarDetail(PengajarModel p) {
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
                Expanded(
                  child: Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showPengajarForm(p);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${p.role} • ${p.subject}', style: const TextStyle(color: AppColors.secondaryText)),
            const SizedBox(height: 8),
            Text('Kontak: ${p.phone}'),
            const Divider(height: 24),
            const Text('Kelas yang Diampu:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: p.classes.map((c) {
                return Chip(
                  label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  backgroundColor: AppColors.lightGreenBadge,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredPengajar;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Data Pengajar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Tambah Pengajar',
            onPressed: () => _showPengajarForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: const InputDecoration(
                hintText: 'Cari pengajar atau bidang...',
                prefixIcon: Icon(Icons.search, color: AppColors.primaryGreen),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('Tidak ada pengajar ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            child: Text(item.name.isNotEmpty ? item.name[0] : 'U'),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.subject}\nKelas: ${item.classes.join(', ')}'),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showPengajarDetail(item),
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
