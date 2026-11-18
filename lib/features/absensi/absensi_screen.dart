
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/firestore_service.dart';

class AbsensiScreen extends StatefulWidget {
  final String? preselectedMeetingId;

  const AbsensiScreen({
    super.key,
    this.preselectedMeetingId,
  });

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  final FirestoreService _firestore = FirestoreService.instance;

  String? _selectedMeetingId;
  final Set<String> _initializingMeetings = {};

  @override
  void initState() {
    super.initState();
    _selectedMeetingId = widget.preselectedMeetingId;
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

  Future<void> _initializeAttendance(
    String meetingId,
    List<GenerusModel> generusList,
  ) async {
    if (_initializingMeetings.contains(meetingId)) return;

    _initializingMeetings.add(meetingId);

    try {
      await _firestore.initializeAbsensiForMeeting(
        meetingId,
        generusList,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyiapkan absensi: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _initializingMeetings.remove(meetingId);
    }
  }

  Future<void> _changeStatus(
    String meetingId,
    AbsensiRecord record,
    AttendanceStatus status,
  ) async {
    try {
      await _firestore.updateAbsensiStatus(
        meetingId: meetingId,
        generusId: record.generusId,
        status: status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status ${record.generusName} berhasil diperbarui.',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui absensi: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildMiniBadge(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceContent(
    String meetingId,
    List<GenerusModel> generusList,
  ) {
    if (generusList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Belum ada data Generus.\nTambahkan Generus terlebih dahulu.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return StreamBuilder<List<AbsensiRecord>>(
      stream: _firestore.watchAbsensiForMeeting(meetingId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat data absensi: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data ?? [];

        if (records.length < generusList.length) {
          _initializeAttendance(meetingId, generusList);

          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Menyiapkan daftar absensi...'),
              ],
            ),
          );
        }

        final countHadir = records
            .where((r) => r.status == AttendanceStatus.hadir)
            .length;
        final countTerlambat = records
            .where((r) => r.status == AttendanceStatus.terlambat)
            .length;
        final countIzin = records
            .where((r) => r.status == AttendanceStatus.izin)
            .length;
        final countSakit = records
            .where((r) => r.status == AttendanceStatus.sakit)
            .length;
        final countAlpa = records
            .where((r) => r.status == AttendanceStatus.alpa)
            .length;

        final percentHadir = records.isEmpty
            ? 0
            : ((countHadir / records.length) * 100).round();

        return Column(
          children: [
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
                        _buildMiniBadge(
                          'Hadir',
                          countHadir,
                          _getStatusColor(AttendanceStatus.hadir),
                        ),
                        _buildMiniBadge(
                          'Terlambat',
                          countTerlambat,
                          _getStatusColor(AttendanceStatus.terlambat),
                        ),
                        _buildMiniBadge(
                          'Izin',
                          countIzin,
                          _getStatusColor(AttendanceStatus.izin),
                        ),
                        _buildMiniBadge(
                          'Sakit',
                          countSakit,
                          _getStatusColor(AttendanceStatus.sakit),
                        ),
                        _buildMiniBadge(
                          'Alpa',
                          countAlpa,
                          _getStatusColor(AttendanceStatus.alpa),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final color = _getStatusColor(record.status);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: color.withValues(alpha: 0.15),
                            child: Text(
                              record.generusName.isNotEmpty
                                  ? record.generusName[0].toUpperCase()
                                  : 'G',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.generusName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Kelas: ${record.generusKelas}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<AttendanceStatus>(
                            tooltip: 'Ubah status kehadiran',
                            onSelected: (status) {
                              _changeStatus(meetingId, record, status);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getStatusLabel(record.status),
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 16,
                                    color: color,
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              return AttendanceStatus.values.map((status) {
                                return PopupMenuItem<AttendanceStatus>(
                                  value: status,
                                  child: Text(_getStatusLabel(status)),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_done,
                    color: AppColors.primaryGreen,
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Perubahan presensi tersimpan otomatis',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        title: const Text('Presensi & Absensi'),
      ),
      body: StreamBuilder<List<PertemuanModel>>(
        stream: _firestore.watchPertemuan(),
        builder: (context, meetingSnapshot) {
          if (meetingSnapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat pertemuan: ${meetingSnapshot.error}',
              ),
            );
          }

          if (meetingSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final meetings = meetingSnapshot.data ?? [];

          if (meetings.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada pertemuan.\nTambahkan pertemuan terlebih dahulu.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final selectedMeeting = meetings.firstWhere(
            (meeting) => meeting.id == _selectedMeetingId,
            orElse: () => meetings.first,
          );

          if (_selectedMeetingId != selectedMeeting.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedMeetingId = selectedMeeting.id;
                });
              }
            });
          }

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Pertemuan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
  initialValue: selectedMeeting.id,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      items: meetings.map((meeting) {
                        return DropdownMenuItem<String>(
                          value: meeting.id,
                          child: Text(
                            '${meeting.title} (${meeting.status})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMeetingId = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<GenerusModel>>(
                  stream: _firestore.watchGenerus(),
                  builder: (context, generusSnapshot) {
                    if (generusSnapshot.hasError) {
                      return Center(
                        child: Text(
                          'Gagal memuat Generus: ${generusSnapshot.error}',
                        ),
                      );
                    }

                    if (generusSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final generusList = generusSnapshot.data ?? [];

                    return _buildAttendanceContent(
                      selectedMeeting.id,
                      generusList,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
