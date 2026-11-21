
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== GENERUS ====================

  CollectionReference<Map<String, dynamic>> get _generusCollection =>
      _db.collection('generus');

  Stream<List<GenerusModel>> watchGenerus() {
    return _generusCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return GenerusModel(
          id: doc.id,
          name: data['name'] ?? '',
          nisn: data['nisn'] ?? '',
          kelas: data['kelas'] ?? '',
          level: data['level'] ?? '',
          gender: data['gender'] ?? '',
          parentName: data['parentName'] ?? '',
          parentPhone: data['parentPhone'] ?? '',
          address: data['address'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addGenerus(GenerusModel generus) async {
    await _generusCollection.add({
      'name': generus.name,
      'nisn': generus.nisn,
      'kelas': generus.kelas,
      'level': generus.level,
      'gender': generus.gender,
      'parentName': generus.parentName,
      'parentPhone': generus.parentPhone,
      'address': generus.address,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateGenerus(GenerusModel generus) async {
    await _generusCollection.doc(generus.id).update({
      'name': generus.name,
      'nisn': generus.nisn,
      'kelas': generus.kelas,
      'level': generus.level,
      'gender': generus.gender,
      'parentName': generus.parentName,
      'parentPhone': generus.parentPhone,
      'address': generus.address,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteGenerus(String id) async {
    await _generusCollection.doc(id).delete();
  }

  // ==================== PENGAJAR ====================

  CollectionReference<Map<String, dynamic>> get _pengajarCollection =>
      _db.collection('pengajar');

  Stream<List<PengajarModel>> watchPengajar() {
    return _pengajarCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return PengajarModel(
          id: doc.id,
          name: data['name'] ?? '',
          role: data['role'] ?? 'Pengajar',
          subject: data['subject'] ?? '',
          classes: List<String>.from(data['classes'] ?? []),
          phone: data['phone'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addPengajar(PengajarModel pengajar) async {
    await _pengajarCollection.add({
      'name': pengajar.name,
      'role': pengajar.role,
      'subject': pengajar.subject,
      'classes': pengajar.classes,
      'phone': pengajar.phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePengajar(PengajarModel pengajar) async {
    await _pengajarCollection.doc(pengajar.id).update({
      'name': pengajar.name,
      'role': pengajar.role,
      'subject': pengajar.subject,
      'classes': pengajar.classes,
      'phone': pengajar.phone,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePengajar(String id) async {
    await _pengajarCollection.doc(id).delete();
  }

  // ==================== KELAS ====================

  CollectionReference<Map<String, dynamic>> get _kelasCollection =>
      _db.collection('kelas');

  Stream<List<KelasModel>> watchKelas() {
    return _kelasCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return KelasModel(
          id: doc.id,
          name: data['name'] ?? '',
          level: data['level'] ?? '',
          teacherName: data['teacherName'] ?? '',
          studentCount: (data['studentCount'] as num?)?.toInt() ?? 0,
          status: data['status'] ?? 'Aktif',
        );
      }).toList();
    });
  }

  Future<void> addKelas(KelasModel kelas) async {
    await _kelasCollection.add({
      'name': kelas.name,
      'level': kelas.level,
      'teacherName': kelas.teacherName,
      'studentCount': kelas.studentCount,
      'status': kelas.status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateKelas(KelasModel kelas) async {
    await _kelasCollection.doc(kelas.id).update({
      'name': kelas.name,
      'level': kelas.level,
      'teacherName': kelas.teacherName,
      'studentCount': kelas.studentCount,
      'status': kelas.status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteKelas(String id) async {
    await _kelasCollection.doc(id).delete();
  }

  // ==================== MATERI ====================

  CollectionReference<Map<String, dynamic>> get _materiCollection =>
      _db.collection('materi');

  Stream<List<MateriModel>> watchMateri() {
    return _materiCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return MateriModel(
          id: doc.id,
          title: data['title'] ?? '',
          category: data['category'] ?? '',
          summary: data['summary'] ?? '',
          detail: data['detail'] ?? '',
          progress: (data['progress'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    });
  }

  Future<void> addMateri(MateriModel materi) async {
    await _materiCollection.add({
      'title': materi.title,
      'category': materi.category,
      'summary': materi.summary,
      'detail': materi.detail,
      'progress': materi.progress,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMateri(MateriModel materi) async {
    await _materiCollection.doc(materi.id).update({
      'title': materi.title,
      'category': materi.category,
      'summary': materi.summary,
      'detail': materi.detail,
      'progress': materi.progress,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteMateri(String id) async {
    await _materiCollection.doc(id).delete();
  }

  // ==================== PERTEMUAN ====================

  CollectionReference<Map<String, dynamic>> get _pertemuanCollection =>
      _db.collection('pertemuan');

  Stream<List<PertemuanModel>> watchPertemuan() {
    return _pertemuanCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return PertemuanModel(
          id: doc.id,
          title: data['title'] ?? '',
          date: data['date'] ?? '',
          time: data['time'] ?? '',
          location: data['location'] ?? '',
          status: data['status'] ?? '',
          description: data['description'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addPertemuan(PertemuanModel pertemuan) async {
    await _pertemuanCollection.add({
      'title': pertemuan.title,
      'date': pertemuan.date,
      'time': pertemuan.time,
      'location': pertemuan.location,
      'status': pertemuan.status,
      'description': pertemuan.description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePertemuan(PertemuanModel pertemuan) async {
    await _pertemuanCollection.doc(pertemuan.id).update({
      'title': pertemuan.title,
      'date': pertemuan.date,
      'time': pertemuan.time,
      'location': pertemuan.location,
      'status': pertemuan.status,
      'description': pertemuan.description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePertemuan(String id) async {
    await _pertemuanCollection.doc(id).delete();
  }

  // ==================== ABSENSI ====================

  CollectionReference<Map<String, dynamic>> get _absensiCollection =>
      _db.collection('absensi');

  Stream<List<AbsensiRecord>> watchAbsensiForMeeting(String meetingId) {
    return _absensiCollection
        .where('meetingId', isEqualTo: meetingId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return AbsensiRecord(
          generusId: data['generusId'] ?? '',
          generusName: data['generusName'] ?? '',
          generusKelas: data['generusKelas'] ?? '',
          status: AttendanceStatus.values.firstWhere(
            (status) => status.name == data['status'],
            orElse: () => AttendanceStatus.hadir,
          ),
        );
      }).toList();
    });
  }

  Future<void> initializeAbsensiForMeeting(
    String meetingId,
    List<GenerusModel> generusList,
  ) async {
    final existing = await _absensiCollection
        .where('meetingId', isEqualTo: meetingId)
        .get();

    final existingIds = existing.docs
        .map((doc) => doc.data()['generusId'])
        .toSet();

    final batch = _db.batch();

    for (final generus in generusList) {
      if (existingIds.contains(generus.id)) continue;

      final documentId = '${meetingId}_${generus.id}';

      batch.set(_absensiCollection.doc(documentId), {
        'meetingId': meetingId,
        'generusId': generus.id,
        'generusName': generus.name,
        'generusKelas': generus.kelas,
        'status': AttendanceStatus.hadir.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> updateAbsensiStatus({
    required String meetingId,
    required String generusId,
    required AttendanceStatus status,
  }) async {
    final documentId = '${meetingId}_$generusId';

    await _absensiCollection.doc(documentId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== PROGRES BELAJAR ====================

  CollectionReference<Map<String, dynamic>> get _progressCollection =>
      _db.collection('progres_belajar');

  Stream<List<Map<String, dynamic>>> watchProgressForGenerus(
    String generusId,
  ) {
    return _progressCollection
        .where('generusId', isEqualTo: generusId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  Future<void> updateProgressBelajar({
    required String generusId,
    required String generusName,
    required String category,
    required int progress,
  }) async {
    final documentId = '${generusId}_${category.toLowerCase()}';

    await _progressCollection.doc(documentId).set({
      'generusId': generusId,
      'generusName': generusName,
      'category': category,
      'progress': progress.clamp(0, 100),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ==================== PRESTASI ====================

  CollectionReference<Map<String, dynamic>> get _prestasiCollection =>
      _db.collection('prestasi');

  Stream<List<PrestasiModel>> watchPrestasi() {
    return _prestasiCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return PrestasiModel(
          id: doc.id,
          generusName: data['generusName'] ?? '',
          title: data['title'] ?? '',
          category: data['category'] ?? '',
          level: data['level'] ?? '',
          date: data['date'] ?? '',
          documentation: data['documentation'] ?? '',
        );
      }).toList();
    });
  }

    Future<void> addPrestasi(PrestasiModel prestasi) async {
    final generusName = prestasi.generusName.trim();
    final normalizedName = generusName.toLowerCase();

    // Periksa apakah Generus sudah terdaftar
    final generusSnapshot = await _generusCollection.get();

    final generusExists = generusSnapshot.docs.any((doc) {
      final existingName = (doc.data()['name'] ?? '')
          .toString()
          .trim()
          .toLowerCase();

      return existingName == normalizedName;
    });

    // Gunakan batch agar penambahan Generus (jika perlu)
    // dan penyimpanan Prestasi dilakukan bersama.
    final batch = _db.batch();

    // Jika Generus belum terdaftar, buat data baru
    if (!generusExists) {
      final newGenerusRef = _generusCollection.doc();

      batch.set(newGenerusRef, {
        'name': generusName,
        'nisn': '',
        'kelas': '',
        'level': '',
        'gender': '',
        'parentName': '',
        'parentPhone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Simpan data Prestasi
    final newPrestasiRef = _prestasiCollection.doc();

    batch.set(newPrestasiRef, {
      'generusName': generusName,
      'title': prestasi.title,
      'category': prestasi.category,
      'level': prestasi.level,
      'date': prestasi.date,
      'documentation': prestasi.documentation,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Jalankan seluruh perubahan
    await batch.commit();
  }

    Future<void> updatePrestasi(PrestasiModel prestasi) async {
      await _prestasiCollection.doc(prestasi.id).update({
        'generusName': prestasi.generusName,
        'title': prestasi.title,
        'category': prestasi.category,
        'level': prestasi.level,
        'date': prestasi.date,
        'documentation': prestasi.documentation,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

  Future<void> deletePrestasi(String id) async {
    await _prestasiCollection.doc(id).delete();
  }

  // ==================== PEMBINAAN ====================

  CollectionReference<Map<String, dynamic>> get _pembinaanCollection =>
      _db.collection('pembinaan');

  Stream<List<PembinaanModel>> watchPembinaan() {
    return _pembinaanCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return PembinaanModel(
          id: doc.id,
          generusName: data['generusName'] ?? '',
          date: data['date'] ?? '',
          category: data['category'] ?? 'Akhlak',
          notes: data['notes'] ?? '',
          followupAction: data['followupAction'] ?? '',
          status: data['status'] ?? 'Dalam Proses',
        );
      }).toList();
    });
  }

  Future<void> addPembinaan(PembinaanModel pembinaan) async {
    await _pembinaanCollection.add({
      'generusName': pembinaan.generusName,
      'date': pembinaan.date,
      'category': pembinaan.category,
      'notes': pembinaan.notes,
      'followupAction': pembinaan.followupAction,
      'status': pembinaan.status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePembinaan(PembinaanModel pembinaan) async {
    await _pembinaanCollection.doc(pembinaan.id).update({
      'generusName': pembinaan.generusName,
      'date': pembinaan.date,
      'category': pembinaan.category,
      'notes': pembinaan.notes,
      'followupAction': pembinaan.followupAction,
      'status': pembinaan.status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePembinaan(String id) async {
    await _pembinaanCollection.doc(id).delete();
  }

    Future<void> syncPrestasiToGenerus() async {
    // Ambil seluruh data Prestasi
    final prestasiSnapshot = await _prestasiCollection.get();

    // Ambil seluruh data Generus
    final generusSnapshot = await _generusCollection.get();

    // Kumpulkan nama Generus yang sudah terdaftar
    final existingNames = generusSnapshot.docs.map((doc) {
      return (doc.data()['name'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
    }).toSet();

    final batch = _db.batch();
    int addedCount = 0;

    for (final doc in prestasiSnapshot.docs) {
      final name = (doc.data()['generusName'] ?? '').toString().trim();
      final normalizedName = name.toLowerCase();

      // Abaikan nama kosong atau yang sudah terdaftar
      if (name.isEmpty || existingNames.contains(normalizedName)) {
        continue;
      }

      final newGenerusRef = _generusCollection.doc();

      batch.set(newGenerusRef, {
        'name': name,
        'nisn': '',
        'kelas': '',
        'level': '',
        'gender': '',
        'parentName': '',
        'parentPhone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Agar nama yang sama dari beberapa Prestasi tidak dibuat berulang
      existingNames.add(normalizedName);
      addedCount++;
    }

    // Simpan hanya jika ada Generus baru
    if (addedCount > 0) {
      await batch.commit();
    }
  }
}
