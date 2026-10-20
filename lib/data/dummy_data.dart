import 'package:flutter/foundation.dart';

import '../models/app_models.dart';

class DummyDataStore extends ChangeNotifier {
  static final DummyDataStore instance = DummyDataStore._internal();
  DummyDataStore._internal() {
    _initData();
  }

  // Demo Auth Session
  bool isLoggedIn = false;

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // Teacher Profile (Dashboard)
  String teacherName = 'Muhammad Heisal Alfarizi';
  String teacherRole = 'Pengajar';

  // Student Profile (Profil Tab)
  String studentName = 'Muhammad Dimaz Albintani';
  String studentRole = 'Pelajar';
  String studentKelas = 'Kelas 5 SD';
  String studentNisn = '12345';
  int tilawahProgress = 80;
  int hafalanProgress = 65;
  int doaProgress = 90;
  int pegonProgress = 75;
  int completedMaterialsCount = 12;
  int totalMaterialsCount = 16;

  // Stats
  int totalGenerus = 250;
  int totalPengajar = 12;
  int totalKelas = 12;
  int attendanceRate = 83;

  // Lists
  final List<GenerusModel> generusList = [];
  final List<PengajarModel> pengajarList = [];
  final List<KelasModel> kelasList = [];
  final List<MateriModel> materiList = [];
  final List<PertemuanModel> pertemuanList = [];
  final List<PembinaanModel> pembinaanList = [];
  final List<PrestasiModel> prestasiList = [];
  final List<LaporanModel> laporanList = [];
  final Map<String, List<AbsensiRecord>> absensiRecords = {};

  void _initData() {
    // Generus
    generusList.addAll([
      GenerusModel(
        id: 'G01',
        name: 'Muhammad Dimaz Albintani',
        nisn: '12345',
        kelas: '5 SD',
        level: 'SD',
        gender: 'Laki-laki',
        parentName: 'Albintani Senior',
        parentPhone: '081234567801',
        address: 'Jl. Melati No. 12, Surabaya',
      ),
      GenerusModel(
        id: 'G02',
        name: 'Ahmad Fadhil Prasetyo',
        nisn: '12346',
        kelas: '5 SD',
        level: 'SD',
        gender: 'Laki-laki',
        parentName: 'Bambang Prasetyo',
        parentPhone: '081234567802',
        address: 'Jl. Mawar No. 4, Surabaya',
      ),
      GenerusModel(
        id: 'G03',
        name: 'Siti Nur Aisyah',
        nisn: '12347',
        kelas: '5 SD',
        level: 'SD',
        gender: 'Perempuan',
        parentName: 'H. Sudirman',
        parentPhone: '081234567803',
        address: 'Jl. Kenanga No. 8, Surabaya',
      ),
      GenerusModel(
        id: 'G04',
        name: 'Rayhan Akbar Maulana',
        nisn: '12348',
        kelas: '6 SD',
        level: 'SD',
        gender: 'Laki-laki',
        parentName: 'Maulana Malik',
        parentPhone: '081234567804',
        address: 'Jl. Pahlawan No. 19, Surabaya',
      ),
      GenerusModel(
        id: 'G05',
        name: 'Fatima Zahra',
        nisn: '12349',
        kelas: '1 SMP',
        level: 'SMP',
        gender: 'Perempuan',
        parentName: 'Drs. Supriyadi',
        parentPhone: '081234567805',
        address: 'Jl. Kusuma Bangsa No. 2, Surabaya',
      ),
      GenerusModel(
        id: 'G06',
        name: 'Bilal Habibi',
        nisn: '12350',
        kelas: 'PAUD A',
        level: 'PAUD',
        gender: 'Laki-laki',
        parentName: 'Habibi Rahman',
        parentPhone: '081234567806',
        address: 'Jl. Anggrek No. 11, Surabaya',
      ),
      GenerusModel(
        id: 'G07',
        name: 'Zulfa Khairunnisa',
        nisn: '12351',
        kelas: '2 SMA',
        level: 'SMA',
        gender: 'Perempuan',
        parentName: 'H. Ridwan',
        parentPhone: '081234567807',
        address: 'Jl. Kartini No. 5, Surabaya',
      ),
      GenerusModel(
        id: 'G08',
        name: 'Ibrahim Al-Ghifari',
        nisn: '12352',
        kelas: '3 SMP',
        level: 'SMP',
        gender: 'Laki-laki',
        parentName: 'Al-Ghifari',
        parentPhone: '081234567808',
        address: 'Jl. Pemuda No. 7, Surabaya',
      ),
    ]);

    // Pengajar
    pengajarList.addAll([
      PengajarModel(
        id: 'T01',
        name: 'Muhammad Heisal Alfarizi',
        role: 'Pengajar Utama',
        subject: 'Tahfidz & Akhlak',
        classes: ['5 SD', '6 SD', '1 SMP'],
        phone: '081122334455',
      ),
      PengajarModel(
        id: 'T02',
        name: 'Ust. Ridwan Kamiludin',
        role: 'Pengajar',
        subject: 'Tilawah & Tajwid',
        classes: ['PAUD A', '1 SD', '2 SD'],
        phone: '081122334456',
      ),
      PengajarModel(
        id: 'T03',
        name: 'Ustazah Annisa Rahma',
        role: 'Pengajar',
        subject: 'Hafalan Doa & Hadist',
        classes: ['3 SD', '4 SD'],
        phone: '081122334457',
      ),
      PengajarModel(
        id: 'T04',
        name: 'Ust. Fauzan Hanif',
        role: 'Pengajar',
        subject: 'Pegon & Fiqih Praktis',
        classes: ['2 SMP', '3 SMP', 'SMA'],
        phone: '081122334458',
      ),
    ]);

    // Kelas
    kelasList.addAll([
      KelasModel(
        id: 'K01',
        name: 'PAUD Generus',
        level: 'PAUD',
        teacherName: 'Ust. Ridwan Kamiludin',
        studentCount: 18,
      ),
      KelasModel(
        id: 'K02',
        name: 'Kelas 1 SD',
        level: 'SD',
        teacherName: 'Ust. Ridwan Kamiludin',
        studentCount: 22,
      ),
      KelasModel(
        id: 'K03',
        name: 'Kelas 2 SD',
        level: 'SD',
        teacherName: 'Ustazah Annisa Rahma',
        studentCount: 20,
      ),
      KelasModel(
        id: 'K04',
        name: 'Kelas 3 SD',
        level: 'SD',
        teacherName: 'Ustazah Annisa Rahma',
        studentCount: 24,
      ),
      KelasModel(
        id: 'K05',
        name: 'Kelas 4 SD',
        level: 'SD',
        teacherName: 'Ust. Fauzan Hanif',
        studentCount: 21,
      ),
      KelasModel(
        id: 'K06',
        name: 'Kelas 5 SD',
        level: 'SD',
        teacherName: 'Muhammad Heisal Alfarizi',
        studentCount: 25,
      ),
      KelasModel(
        id: 'K07',
        name: 'Kelas 6 SD',
        level: 'SD',
        teacherName: 'Muhammad Heisal Alfarizi',
        studentCount: 23,
      ),
      KelasModel(
        id: 'K08',
        name: 'Kelas 1 SMP',
        level: 'SMP',
        teacherName: 'Muhammad Heisal Alfarizi',
        studentCount: 26,
      ),
      KelasModel(
        id: 'K09',
        name: 'Kelas 2 SMP',
        level: 'SMP',
        teacherName: 'Ust. Fauzan Hanif',
        studentCount: 20,
      ),
      KelasModel(
        id: 'K10',
        name: 'Kelas 3 SMP',
        level: 'SMP',
        teacherName: 'Ust. Fauzan Hanif',
        studentCount: 19,
      ),
      KelasModel(
        id: 'K11',
        name: 'Kelas 1 SMA',
        level: 'SMA',
        teacherName: 'Ust. Fauzan Hanif',
        studentCount: 17,
      ),
      KelasModel(
        id: 'K12',
        name: 'Kelas 2 & 3 SMA',
        level: 'SMA',
        teacherName: 'Muhammad Heisal Alfarizi',
        studentCount: 15,
      ),
    ]);

    // Materi (at least 8 as per PRD)
    materiList.addAll([
      MateriModel(
        id: 'M01',
        title: "Dasar Membaca Al-Qur'an",
        category: 'Tilawah',
        summary: 'Pengenalan huruf hijaiyah berharakat dan makhraj dasar.',
        detail: 'Mempelajari cara pengucapan 29 huruf hijaiyah sesuai makharijul huruf serta tanda baca fat-hah, kasrah, dhammah.',
        progress: 90,
      ),
      MateriModel(
        id: 'M02',
        title: 'Hukum Bacaan Nun Sukun',
        category: 'Tilawah',
        summary: 'Penjelasan Izhar, Idgham, Iqlab, dan Ikhfa.',
        detail: 'Kaidah membaca hukum nun mati/tanwin saat bertemu 28 huruf hijaiyah disertai latihan praktik ayat per ayat.',
        progress: 85,
      ),
      MateriModel(
        id: 'M03',
        title: 'Makharijul Huruf',
        category: 'Tilawah',
        summary: 'Penyempurnaan titik keluar suara huruf Al-Halq dan Al-Lisan.',
        detail: 'Fokus pada ketepatan bunyi huruf tebal dan tipis (istila dan istifal) dalam bacaan sholat dan Al-Quran.',
        progress: 75,
      ),
      MateriModel(
        id: 'M04',
        title: 'Surah Al-Mulk',
        category: 'Hafalan',
        summary: 'Hafalan ayat 1-30 berserta tajwid dan intonasi.',
        detail: 'Hafalan bertahap per 5 ayat setiap pekan, evaluasi kelancaran dan pemaknaan singkat kandungan surah.',
        progress: 65,
      ),
      MateriModel(
        id: 'M05',
        title: 'Surah Ar-Rahman',
        category: 'Hafalan',
        summary: 'Hafalan ayat 1-78 dengan tartil.',
        detail: 'Pembiasaan melafalkan pengulangan ayat Fabiayyi aalaai Rabbikuma tukadzdzibaan dengan ketukan tartil.',
        progress: 60,
      ),
      MateriModel(
        id: 'M06',
        title: 'Doa Sebelum Belajar',
        category: 'Doa',
        summary: 'Lafadz dan arti doa memohon kemudahan ilmu.',
        detail: 'Robbi zidni ilma warzuqni fahma. Dilafalkan bersama setiap awal kegiatan pembelajaran generus.',
        progress: 100,
      ),
      MateriModel(
        id: 'M07',
        title: 'Doa Setelah Belajar',
        category: 'Doa',
        summary: 'Doa penutup majelis dan syukur atas pemahaman.',
        detail: 'Subhanakallahumma wabihamdika asyhadu alla ilaha illa anta astaghfiruka wa atubu ilaik.',
        progress: 95,
      ),
      MateriModel(
        id: 'M08',
        title: 'Dasar Membaca Pegon',
        category: 'Pegon',
        summary: 'Kaidah tulisan abjad pegon aksara jawi/Indonesia.',
        detail: 'Pengenalan simbol huruf pegon, gandengan huruf, serta latihan menulis dan membaca teks syarah hadits pegon.',
        progress: 70,
      ),
    ]);

    // Pertemuan (at least 6 as per PRD)
    pertemuanList.addAll([
      PertemuanModel(
        id: 'P01',
        title: 'Pembinaan Generus Mingguan',
        date: 'Minggu, 25 Oktober 2026',
        time: '08:00 - 10:30 WIB',
        location: 'Aula Utama Baitul Makmur',
        status: 'Akan Datang',
        description: 'Pembinaan karakter mandiri, alim-faqih, dan berakhlakul karimah untuk seluruh jenjang.',
      ),
      PertemuanModel(
        id: 'P02',
        title: 'Evaluasi Hafalan',
        date: 'Selasa, 27 Oktober 2026',
        time: '18:30 - 20:00 WIB',
        location: 'Ruang Tahfidz Masjid',
        status: 'Akan Datang',
        description: 'Setoran hafalan Surah Al-Mulk dan surat pilihan juz 30.',
      ),
      PertemuanModel(
        id: 'P03',
        title: 'Kelas Tilawah',
        date: 'Jumat, 30 Oktober 2026',
        time: '16:00 - 17:30 WIB',
        location: 'Serambi Timur Masjid',
        status: 'Akan Datang',
        description:
            'Pendalaman makharijul huruf dan tajwid nun sukun praktis.',
      ),
      PertemuanModel(
        id: 'P04',
        title: 'Pertemuan Evaluasi Bulanan',
        date: 'Minggu, 11 Oktober 2026',
        time: '09:00 - 11:30 WIB',
        location: 'Aula Serbaguna',
        status: 'Selesai',
        description:
            'Evaluasi absensi kehadiran dan capaian kurikulum kuartal ketiga.',
      ),
      PertemuanModel(
        id: 'P05',
        title: 'Pembinaan Akhlak',
        date: 'Kamis, 08 Oktober 2026',
        time: '19:30 - 21:00 WIB',
        location: 'Masjid Lantai 2',
        status: 'Selesai',
        description: 'Kajian adab terhadap orang tua, guru, dan sesama teman.',
      ),
      PertemuanModel(
        id: 'P06',
        title: 'Latihan Hafalan',
        date: 'Senin, 05 Oktober 2026',
        time: '18:30 - 20:00 WIB',
        location: 'Ruang Kelas 5 SD',
        status: 'Selesai',
        description: 'Murojaah mandiri berkelompok dipandu pengajar muda.',
      ),
    ]);

    // Absensi dummy init for first meeting
    absensiRecords['P01'] = generusList.map((g) {
      return AbsensiRecord(
        generusId: g.id,
        generusName: g.name,
        generusKelas: g.kelas,
        status: AttendanceStatus.hadir,
      );
    }).toList();

    // Pembinaan
    pembinaanList.addAll([
      PembinaanModel(
        id: 'PB01',
        generusName: 'Muhammad Dimaz Albintani',
        date: '14 Okt 2026',
        category: 'Kedisiplinan',
        notes: 'Sangat aktif dalam halaqah tahfidz dan sholat tepat waktu.',
        followupAction: 'Diusulkan menjadi ketua regu hafalan pekan depan.',
        status: 'Selesai',
      ),
      PembinaanModel(
        id: 'PB02',
        generusName: 'Ahmad Fadhil Prasetyo',
        date: '12 Okt 2026',
        category: 'Motivasi',
        notes: 'Perlu penguatan motivasi murojaah surah panjang.',
        followupAction:
            'Jadwalkan pendampingan khusus bersama pengajar tahfidz.',
        status: 'Dalam Proses',
      ),
      PembinaanModel(
        id: 'PB03',
        generusName: 'Rayhan Akbar Maulana',
        date: '09 Okt 2026',
        category: 'Akhlak',
        notes:
            'Menunjukkan sopan santun yang teladan kepada pengajar dan teman.',
        followupAction: 'Apresiasi pada saat apel pembinaan generus.',
        status: 'Selesai',
      ),
      PembinaanModel(
        id: 'PB04',
        generusName: 'Fatima Zahra',
        date: '03 Okt 2026',
        category: 'Ibadah',
        notes: 'Konsisten mencatat jurnal amalan yaumiyah mandiri.',
        followupAction: 'Pertahankan dan beri bintang prestasi pembinaan.',
        status: 'Selesai',
      ),
    ]);

    // Prestasi
    prestasiList.addAll([
      PrestasiModel(
        id: 'PR01',
        generusName: 'Muhammad Dimaz Albintani',
        title: 'Juara 1 Tahfidz Juz 30 Tingkat Kecamatan',
        category: 'Tahfidz',
        level: 'Kecamatan',
        date: 'Agustus 2026',
        documentation: 'Sertifikat & Piala Juara 1',
      ),
      PrestasiModel(
        id: 'PR02',
        generusName: 'Siti Nur Aisyah',
        title: 'Juara 2 Lomba Tartil Al-Qur\'an Anak',
        category: 'Tilawah',
        level: 'Kabupaten',
        date: 'Juli 2026',
        documentation: 'Piagam Penghargaan Resmi LPTQ',
      ),
      PrestasiModel(
        id: 'PR03',
        generusName: 'Rayhan Akbar Maulana',
        title: 'Juara Harapan Cerdas Cermat Diniyah',
        category: 'Akademik',
        level: 'Kabupaten',
        date: 'September 2026',
        documentation: 'Sertifikat Finalis',
      ),
      PrestasiModel(
        id: 'PR04',
        generusName: 'Zulfa Khairunnisa',
        title: 'Juara 1 Kaligrafi Arab & Pegon',
        category: 'Seni',
        level: 'Provinsi',
        date: 'Mei 2026',
        documentation: 'Medali Emas & Piagam Prestasi',
      ),
    ]);

    // Laporan (5 items minimum as per PRD)
    laporanList.addAll([
      LaporanModel(
        id: 'L01',
        title: 'Laporan Kehadiran Mingguan',
        date: '16 Okt 2026',
        category: 'Absensi',
        summary: 'Tingkat kehadiran pekan ke-3 mencapai 83% dengan total 208 hadir dari 250 generus.',
        status: 'Final',
      ),
      LaporanModel(
        id: 'L02',
        title: 'Laporan Progres Hafalan',
        date: '14 Okt 2026',
        category: 'Progress',
        summary: 'Pencapaian target juz 30 dan surah Al-Mulk mencapai rata-rata 65% di jenjang SD.',
        status: 'Final',
      ),
      LaporanModel(
        id: 'L03',
        title: 'Laporan Kegiatan Pembinaan',
        date: '10 Okt 2026',
        category: 'Pembinaan',
        summary: 'Catatan pembinaan akhlak dan kemandirian mencakup 4 tindak lanjut aktif.',
        status: 'Final',
      ),
      LaporanModel(
        id: 'L04',
        title: 'Laporan Evaluasi Kelas',
        date: '08 Okt 2026',
        category: 'Kelas',
        summary: 'Sebanyak 12 kelas aktif berjalan normal dengan keterlibatan penuh 12 pengajar.',
        status: 'Final',
      ),
      LaporanModel(
        id: 'L05',
        title: 'Laporan Perkembangan Generus',
        date: '01 Okt 2026',
        category: 'Generus',
        summary: 'Rekapitulasi berkala perkembangan tilawah, pegon, dan amalan ibadah generus bulanan.',
        status: 'Final',
      ),
    ]);
  }

  // Mutators for local state
  void addGenerus(GenerusModel generus) {
    generusList.insert(0, generus);
    totalGenerus = generusList.length + 242; // maintain statistical balance
    notifyListeners();
  }

  void updateGenerus(GenerusModel updated) {
    final idx = generusList.indexWhere((g) => g.id == updated.id);
    if (idx != -1) {
      generusList[idx] = updated;
      notifyListeners();
    }
  }

  void addPengajar(PengajarModel pengajar) {
    pengajarList.insert(0, pengajar);
    totalPengajar = pengajarList.length + 8;
    notifyListeners();
  }

  void updatePengajar(PengajarModel updated) {
    final idx = pengajarList.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      pengajarList[idx] = updated;
      notifyListeners();
    }
  }

  void addPertemuan(PertemuanModel pertemuan) {
    pertemuanList.insert(0, pertemuan);
    notifyListeners();
  }

  void addPembinaan(PembinaanModel pb) {
    pembinaanList.insert(0, pb);
    notifyListeners();
  }

  void updatePembinaan(PembinaanModel updated) {
    final idx = pembinaanList.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      pembinaanList[idx] = updated;
      notifyListeners();
    }
  }

  void addPrestasi(PrestasiModel pr) {
    prestasiList.insert(0, pr);
    notifyListeners();
  }

  List<AbsensiRecord> getAbsensiForMeeting(String meetingId) {
    if (!absensiRecords.containsKey(meetingId)) {
      absensiRecords[meetingId] = generusList.map((g) {
        return AbsensiRecord(
          generusId: g.id,
          generusName: g.name,
          generusKelas: g.kelas,
          status: AttendanceStatus.hadir,
        );
      }).toList();
    }
    return absensiRecords[meetingId]!;
  }

  void updateAttendance(
    String meetingId,
    String generusId,
    AttendanceStatus status,
  ) {
    final list = getAbsensiForMeeting(meetingId);
    final item = list.firstWhere(
      (r) => r.generusId == generusId,
      orElse: () => list.first,
    );
    item.status = status;
    notifyListeners();
  }
}
