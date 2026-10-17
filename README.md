# SIAP-GENERUS Mobile Application

Aplikasi administrasi dan pembinaan generus berbasis Flutter (Android/Multiplatform) dengan data dummy lokal interaktif.

## Fitur Utama

- **Login Demo:** Autentikasi simulasi lokal dengan palet hijau brand.
- **Beranda (Dashboard):** Statistik ringkasan (Total Generus, Kelas Aktif, Rata-rata Kehadiran) dan shortcut modul.
- **Materi:** Kurikulum Tilawah, Hafalan, Doa, dan Pegon dengan pencarian serta filter kategori.
- **Pertemuan:** Jadwal kegiatan (Akan Datang / Selesai), filter, dan pembuatan jadwal baru.
- **Laporan:** Pusat rekapitulasi data generus, kelas, presensi, materi, progres, dan pembinaan.
- **Profil:** Capaian belajar pelajar (Tilawah, Hafalan, Doa, Pegon) serta pengaturan profil & logout demo.
- **Modul Tambahan:** Manajemen Generus, Pengajar, Kelas jenjang PAUD-SMA, Presensi/Absensi interaktif, Catatan Pembinaan, dan Data Prestasi.

---

## Kredensial Demo

| Field | Nilai |
|---|---|
| **Email** | `demo@siapgenerus.app` |
| **Password** | `Generus123!` |

---

## Prasyarat

- Flutter SDK `^3.13` atau lebih baru
- Dart SDK `^3.0`
- Android Studio / VS Code dengan Flutter extension
- Emulator Android, Chrome, atau perangkat fisik

---

## Cara Menjalankan

1. **Clone repository:**
   ```bash
   git clone <URL_REPO_GITHUB>
   cd siap_generus
   ```

2. **Ambil dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

   Jalankan di target spesifik bila diperlukan:
   ```bash
   # Android emulator / device
   flutter run -d android

   # Web Chrome
   flutter run -d chrome

   # Windows desktop
   flutter run -d windows
   ```

4. **Jalankan pengujian dan analisis kode:**
   ```bash
   flutter analyze
   flutter test
   ```
