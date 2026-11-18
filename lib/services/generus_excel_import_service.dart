
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class GenerusExcelImportResult {
  final int imported;
  final int skipped;

  const GenerusExcelImportResult({
    required this.imported,
    required this.skipped,
  });
}

class GenerusExcelImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GenerusExcelImportResult> importExcel() async {
    // Pilih file Excel
    final pickedFiles = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (pickedFiles.isEmpty) {
      return const GenerusExcelImportResult(
        imported: 0,
        skipped: 0,
      );
    }

    // Baca isi file
    final pickedFile = pickedFiles.first;
    final bytes = await pickedFile.readAsBytes();

    final excel = Excel.decodeBytes(bytes);

    // Ambil sheet Rekap Santri
    Sheet? sheet;

    if (excel.tables.containsKey('Rekap Santri')) {
      sheet = excel.tables['Rekap Santri'];
    } else if (excel.tables.isNotEmpty) {
      sheet = excel.tables.values.first;
    }

    if (sheet == null || sheet.rows.isEmpty) {
      throw Exception('Sheet Excel tidak ditemukan atau kosong.');
    }

    // Cari baris header
    int headerRowIndex = -1;
    final Map<String, int> headers = {};

    for (int i = 0; i < sheet.rows.length && i < 15; i++) {
      final row = sheet.rows[i];

      final tempHeaders = <String, int>{};

      for (int j = 0; j < row.length; j++) {
        final header = _normalize(row[j]?.value);

        if (header.isNotEmpty) {
          tempHeaders[header] = j;
        }
      }

      if (tempHeaders.containsKey('nama lengkap')) {
        headerRowIndex = i;
        headers.addAll(tempHeaders);
        break;
      }
    }

    if (headerRowIndex == -1) {
      throw Exception(
        'Kolom Nama Lengkap tidak ditemukan pada file Excel.',
      );
    }

    // Ambil data Generus yang sudah ada
    final existingSnapshot =
        await _firestore.collection('generus').get();

    final existingKeys = <String>{};

    for (final doc in existingSnapshot.docs) {
      final data = doc.data();

      final name = _normalize(data['name']);
      final kelas = _normalize(data['kelas']);

      existingKeys.add('$name|$kelas');
    }

    final batch = _firestore.batch();

    int imported = 0;
    int skipped = 0;

    // Baca setiap baris data
    for (
      int i = headerRowIndex + 1;
      i < sheet.rows.length;
      i++
    ) {
      final row = sheet.rows[i];

      final name = _getValue(row, headers, 'nama lengkap');
      final kelas = _getValue(row, headers, 'kelas');

      // Lewati baris tanpa nama
      if (name.isEmpty) {
        continue;
      }

      // Cegah data duplikat berdasarkan nama dan kelas
      final duplicateKey =
          '${_normalize(name)}|${_normalize(kelas)}';

      if (existingKeys.contains(duplicateKey)) {
        skipped++;
        continue;
      }

      final gender = _getValue(
        row,
        headers,
        'jenis kelamin',
      );

      final fatherName = _getValue(
        row,
        headers,
        'nama ayah',
      );

      final motherName = _getValue(
        row,
        headers,
        'nama ibu',
      );

      final parentNames = <String>[];

      if (fatherName.isNotEmpty) {
        parentNames.add(fatherName);
      }

      if (motherName.isNotEmpty) {
        parentNames.add(motherName);
      }

      final parentName = parentNames.join(' / ');

      final phone = _getValue(
        row,
        headers,
        'no. whatsapp aktif',
      );

      final address = _getValue(
        row,
        headers,
        'alamat lengkap',
      );

      final level = _getLevel(
        kelas,
        _getValue(row, headers, 'asal sekolah'),
      );

      // Buat dokumen baru di Firestore
      final document = _firestore
          .collection('generus')
          .doc();

      batch.set(document, {
        'name': name,
        'nisn': '',
        'kelas': kelas,
        'level': level,
        'gender': _getGender(gender),
        'parentName': parentName,
        'parentPhone': phone,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
        'importSource': 'Excel',
      });

      existingKeys.add(duplicateKey);
      imported++;
    }

    // Simpan seluruh data ke Firestore
    if (imported > 0) {
      await batch.commit();
    }

    return GenerusExcelImportResult(
      imported: imported,
      skipped: skipped,
    );
  }

  // Mengambil nilai berdasarkan nama kolom
  String _getValue(
    List<Data?> row,
    Map<String, int> headers,
    String columnName,
  ) {
    final index = headers[_normalize(columnName)];

    if (index == null || index >= row.length) {
      return '';
    }

    return _value(row[index]?.value);
  }

  // Mengubah nilai Excel menjadi teks
  String _value(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  // Menyamakan format teks untuk pencarian header dan duplikat
  String _normalize(dynamic value) {
    return _value(value)
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // Menyesuaikan jenis kelamin
  String _getGender(String value) {
    final gender = value.toLowerCase().trim();

    if (gender == 'l' ||
        gender == 'laki-laki' ||
        gender == 'laki laki' ||
        gender == 'putra') {
      return 'Laki-laki';
    }

    if (gender == 'p' ||
        gender == 'perempuan' ||
        gender == 'putri') {
      return 'Perempuan';
    }

    return value;
  }

  // Menentukan level berdasarkan kelas atau asal sekolah
  String _getLevel(String kelas, String asalSekolah) {
    final value = '$kelas $asalSekolah'.toLowerCase();

    if (value.contains('paud') ||
        value.contains('tk') ||
        value.contains('taman kanak')) {
      return 'PAUD';
    }

    if (value.contains('smp') ||
        value.contains('mts')) {
      return 'SMP';
    }

    if (value.contains('sma') ||
        value.contains('smk') ||
        value.contains('ma')) {
      return 'SMA';
    }

    if (value.contains('sd') ||
        value.contains('mi')) {
      return 'SD';
    }

    return '';
  }
}
