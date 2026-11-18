
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class PengajarListScreen extends StatefulWidget {
  const PengajarListScreen({super.key});

  @override
  State<PengajarListScreen> createState() => _PengajarListScreenState();
}

class _PengajarListScreenState extends State<PengajarListScreen> {
  final FirestoreService _firestore = FirestoreService.instance;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  void _showPengajarForm([PengajarModel? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final roleCtrl = TextEditingController(text: existing?.role ?? 'Pengajar');
    final subjectCtrl = TextEditingController(text: existing?.subject ?? '');
    final classesCtrl = TextEditingController(
      text: existing?.classes.join(', ') ?? '5 SD, 6 SD',
    );
    final phoneCtrl = TextEditingController(
      text: existing?.phone ?? '081234567890',
    );
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: roleCtrl,
                  decoration: const InputDecoration(labelText: 'Peran / Jabatan'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Bidang Pembinaan / Mata Pelajaran',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: classesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kelas yang Diampu (pisahkan koma)',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Nomor Kontak'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final splitClasses = classesCtrl.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      final pengajar = PengajarModel(
                        id: existing?.id ?? '',
                        name: nameCtrl.text.trim(),
                        role: roleCtrl.text.trim().isEmpty
                            ? 'Pengajar'
                            : roleCtrl.text.trim(),
                        subject: subjectCtrl.text.trim(),
                        classes: splitClasses,
                        phone: phoneCtrl.text.trim(),
                      );

                      try {
                        if (existing == null) {
                          await _firestore.addPengajar(pengajar);
                        } else {
                          await _firestore.updatePengajar(pengajar);
                        }

                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              existing == null
                                  ? 'Pengajar berhasil ditambahkan!'
                                  : 'Data pengajar berhasil diperbarui!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menyimpan pengajar: $e'),
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
                Expanded(
                  child: Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showPengajarForm(p);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Hapus Pengajar?'),
                        content: Text('Hapus data ${p.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, true),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    try {
                      await _firestore.deletePengajar(p.id);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pengajar berhasil dihapus'),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menghapus pengajar: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${p.role} • ${p.subject}',
              style: const TextStyle(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 8),
            Text('Kontak: ${p.phone}'),
            const Divider(height: 24),
            const Text(
              'Kelas yang Diampu:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: p.classes.map((c) {
                return Chip(
                  label: Text(
                    c,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
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
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PengajarModel>>(
              stream: _firestore.watchPengajar(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat data pengajar.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allPengajar = snapshot.data ?? [];
                final query = _searchQuery.toLowerCase();

                final list = allPengajar.where((p) {
                  return query.isEmpty ||
                      p.name.toLowerCase().contains(query) ||
                      p.subject.toLowerCase().contains(query);
                }).toList();

                if (list.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada pengajar ditemukan'),
                  );
                }

                return ListView.builder(
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
                          child: Text(
                            item.name.isNotEmpty ? item.name[0] : 'U',
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item.subject}\nKelas: ${item.classes.join(', ')}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _showPengajarDetail(item),
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
}
