# Smart Study Hub Native · 0.1.0

Prototipe Flutter berdasarkan PRD/ERD 2.0 dan keputusan 18 Oktober 2026.
Antarmuka putih dengan aksen sage, biru lembut, dan lavender; chart native Canvas.

## Coba alurnya

Pilih peran di kanan atas. Pada ponsel, gunakan tombol menu.

1. Ringkasan: pilih grafik 7 hari atau 4 minggu. Analitik berupa data ilustrasi.
2. Siswa → Pembelajaran: buka lesson 2 dan tandai selesai untuk membuka lesson 3.
3. Guru → Pembelajaran: ubah akses terbuka, terkunci, atau bersyarat. Coba pembaruan aset kelas berversi.
4. Admin → Ujian: atur pengacakan soal dan pilihan secara terpisah. Esai menonaktifkan nilai langsung. Sahkan paket.
5. Pengawas → Ruang pengawas: jeda ruang/individu, majukan jam demo 15 menit, lalu berikan tambahan waktu. Jeda individu tetap berlaku saat ruang dilanjutkan.
6. Menu peserta: pindah perangkat memerlukan persetujuan risiko; penghentian pelanggaran memerlukan alasan; sesi final tidak dapat dilanjutkan.
7. Guru → Hasil: simulasikan penilaian selesai. Untuk ujian resmi, ganti ke Admin untuk menerbitkan, lalu ke Siswa untuk melihat nilai.
8. Arsip: lihat riwayat semester yang terpisah dari progres sekarang.

## Batas prototipe

- Data sintetis di memori; perubahan hilang setelah proses ditutup.
- Pemilih peran adalah alat demonstrasi, bukan autentikasi/otorisasi aman.
- Jam demo dimajukan melalui tombol. Belum menjadi timer atau jam server operasional.
- Aturan perangkat/ACK merupakan simulasi model domain. Belum ada sinkronisasi, SQLite, enkripsi, pairing, heartbeat, atau pemantauan aktivitas nyata.
- Editor pengerjaan ujian siswa, kolaborasi bank soal, unggah/unduh berkas, penyuntingan jadwal dan roster belum terintegrasi.
- Bukan aplikasi siap ujian produksi. Build Android demo memakai signing pengembangan.
- Windows, macOS dan iOS membutuhkan toolchain dan verifikasi pada OS masing-masing.

## Menjalankan

Baseline Flutter 3.35.7 / Dart 3.9.2, JDK 17. Jika direktori host platform belum ada, jalankan `python3 tools/bootstrap.py` terlebih dahulu. Script membuat host native tanpa menimpa kode aplikasi.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

Tidak membutuhkan akun ChatGPT atau OpenAI API untuk dijalankan.

Di lingkungan CI, gunakan `CI=true` dan `FLUTTER_SUPPRESS_ANALYTICS=true` untuk
menonaktifkan analitik dan melewati deteksi otomatis metadata lingkungan cloud.
Android membutuhkan JDK lengkap (termasuk `javac`), Android SDK 36,
build-tools 35.0.0, NDK 27.0.12077973, dan CMake 3.22.1.
Jangan menyimpan konfigurasi proxy atau kredensial mesin build di kode sumber.

Pratinjau dapat dibuat dengan mengatur `FLUTTER_ROOT` ke direktori SDK lalu
menjalankan `flutter test test/render_previews.dart --update-goldens`.
Belum diuji pada perangkat Android fisik, Windows, macOS, atau iOS.

## Hasil pemeriksaan

- Analisis Flutter: tidak ada temuan.
- Pengujian: 16 lulus, terdiri dari 12 skenario domain dan 4 skenario widget.
- Keenam halaman diperiksa pada 1440 × 1000 dan 390 × 844.
- Tampilan ponsel juga diperiksa dengan skala teks 150%.
- Pratinjau desktop, ponsel, dan ruang pengawas berhasil dirender dan diperiksa.
  Berkas PNG tersedia di `test/previews/`.

## Struktur

`lib/domain.dart` berisi aturan sesi, waktu, perangkat, penilaian, akses materi.
`lib/store.dart` menyimpan data contoh. Berkas UI dipisahkan dari model.
`test/` berisi 12 skenario domain, 4 skenario widget, dan renderer pratinjau.

Tahap berikutnya: autentikasi multi-tenant, repository API, ledger jam server, jurnal lokal terenkripsi, ACK berurutan, serta pengujian gangguan lintas perangkat.
