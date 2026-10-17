import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/app_models.dart';

class AbsensiScreen extends StatefulWidget {
  final String? preselectedMeetingId;
  const AbsensiScreen({super.key, this.preselectedMeetingId});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  final DummyDataStore _dataStore = DummyDataStore.instance;
  late String _selectedMeetingId;

  @override
  void initState() {
    super.initState();
    _selectedMeetingId = widget.preselectedMeetingId ??
        (_dataStore.pertemuanList.isNotEmpty ? _dataStore.pertemuanList.first.id : 'P01');
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

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.hadir:
        return AppColors.secondaryGreen;
      case AttendanceStatus.terlambat:
        return const Color(0xFFE67E22);
      case AttendanceStatus.izin:
        return const Color(0xFF2980B9);
      case AttendanceStatus.sakit:
        return const Color(0xFF8E44AD);
      case AttendanceStatus.alpa:
        return AppColors.badgeRed;
    }
  }

  String _getStatusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.hadir:
        return 'Hadir';
      case AttendanceStatus.terlambat:
        return 'Terlambat';
      case AttendanceStatus.izin:
        return 'Izin';
      case AttendanceStatus.sakit:
        return 'Sakit';
      case AttendanceStatus.alpa:
        return 'Alpa';
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetings = _dataStore.pertemuanList;
    final records = _dataStore.getAbsensiForMeeting(_selectedMeetingId);

    // Rekap counts
    int countHadir = records.where((r) => r.status == AttendanceStatus.hadir).length;
    int countTerlambat = records.where((r) => r.status == AttendanceStatus.terlambat).length;
    int countIzin = records.where((r) => r.status == AttendanceStatus.izin).length;
    int countSakit = records.where((r) => r.status == AttendanceStatus.sakit).length;
    int countAlpa = records.where((r) => r.status == AttendanceStatus.alpa).length;
    int total = records.isNotEmpty ? records.length : 1;
    int percentHadir = ((countHadir / total) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Presensi & Absensi'),
      ),
      body: Column(
        children: [
          // Select Meeting header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Pertemuan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedMeetingId,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  items: meetings.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(
                        '${m.title} (${m.status})',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMeetingId = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Rekap Absensi Header Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekapitulasi Kehadiran',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '$percentHadir% Hadir',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniBadge('Hadir', countHadir, _getStatusColor(AttendanceStatus.hadir)),
                      _buildMiniBadge('Terlambat', countTerlambat, _getStatusColor(AttendanceStatus.terlambat)),
                      _buildMiniBadge('Izin', countIzin, _getStatusColor(AttendanceStatus.izin)),
                      _buildMiniBadge('Sakit', countSakit, _getStatusColor(AttendanceStatus.sakit)),
                      _buildMiniBadge('Alpa', countAlpa, _getStatusColor(AttendanceStatus.alpa)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Generus Attendance List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: records.length,
              itemBuilder: (ctx, index) {
                final rec = records[index];
                final color = _getStatusColor(rec.status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Text(
                            rec.generusName.isNotEmpty ? rec.generusName[0] : 'G',
                            style: TextStyle(color: color, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rec.generusName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Kelas: ${rec.generusKelas}',
                                style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Status selector popup
                        PopupMenuButton<AttendanceStatus>(
                          initialValue: rec.status,
                          onSelected: (st) {
                            setState(() {
                              rec.status = st;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getStatusLabel(rec.status),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down, size: 16, color: color),
                              ],
                            ),
                          ),
                          itemBuilder: (ctx) => AttendanceStatus.values.map((st) {
                            return PopupMenuItem(
                              value: st,
                              child: Text(_getStatusLabel(st)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Save Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_rounded),
                label: const Text('Simpan Presensi (Lokal)'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Presensi berhasil diperbarui secara lokal.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.secondaryText, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
