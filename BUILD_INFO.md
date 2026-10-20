# Smart Study Hub Native 0.1.0

Status: APK prototipe berhasil dibangun. Data sintetis hanya tersimpan di memori.

## Android

- Nama: Smart Study Hub
- Application ID: `biz.canora.smart_study_hub`
- Versi: `0.1.0` / versionCode `1`
- Minimum: Android 7.0 / API 24
- Target dan compile SDK: API 36
- Arsitektur: `armeabi-v7a`, `arm64-v8a`, `x86_64`
- Ukuran APK: 46.667.007 byte
- Signing pengembangan; verifikasi APK Signature Scheme v2 berhasil.
- Integritas ZIP APK berhasil diperiksa.
- SHA-256: `e5a66da5d442b2585afc08e3d524d05502133be8cf242a5e9ea826e9d70fc164`

## Verifikasi

- `flutter analyze`: tidak ada temuan.
- `flutter test`: 16 pengujian lulus.
- Tiga render pratinjau berhasil dan diperiksa secara visual.
- `flutter build apk --release`: berhasil.
- `apksigner verify --verbose`: berhasil.
- Belum diuji pada perangkat Android fisik atau emulator Android.
- Build Windows, macOS, dan iOS belum diverifikasi.

## Mencoba

Unduh `Smart_Study_Hub.apk` pada perangkat Android, buka berkasnya, lalu ikuti
petunjuk pemasangan Android. Pilih peran dari menu kanan atas untuk mencoba
alur di README. Aplikasi tidak memerlukan akun atau server untuk demo ini.
Perubahan akan direset saat proses aplikasi ditutup.

APK ini ditujukan untuk meninjau antarmuka dan simulasi aturan, belum untuk
pelaksanaan ujian sekolah. Signing produksi dan backend belum disiapkan.
