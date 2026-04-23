# Service Addition Guide - Dashboard BSI Clinic

## Overview
Dokumentasi ini menjelaskan cara menambahkan service sederhana ke ServiceGrid di dashboard menggunakan contoh fitur "Detox Calendar".

## Struktur Proyek
```
mobile_app/
├── lib/
│   ├── models/              # Model data (ServiceModel sudah ada)
│   ├── widgets/             # Widget components (ServiceGrid sudah ada)
│   └── screens/
│       └── home/             # Home screen
├── assets/
│   └── data/                 # Data JSON untuk services
└── pubspec.yaml              # Konfigurasi dependencies
```

## Cara Menambahkan Service Baru

### Langkah 1: Tambahkan Service ke services.json

**File:** `assets/data/services.json`

Tambahkan entry baru untuk service yang ingin ditambahkan. Contoh untuk Detox Calendar:

```json
[
  {"id":1,"name":"BSI Signature\nEvidence-Based","icon":"microscope","route":"/service/1","description":"Paket layanan unggulan BSI berbasis bukti ilmiah.","price":""},
  {"id":2,"name":"Blood &\nUrine Tests","icon":"test_tube","route":"/service/2","description":"Pemeriksaan darah dan urin lengkap.","price":""},
  {"id":3,"name":"IV Therapy","icon":"iv_bag","route":"/service/3","description":"Terapi infus intravena untuk meningkatkan imunitas.","price":""},
  {"id":4,"name":"Book\nAppointment","icon":"calendar","route":"/book-appointment","description":"Pesan janji temu dengan dokter.","price":""},
  {"id":5,"name":"Chat Us","icon":"chat","route":"/chat","description":"Hubungi staf klinik BSI.","price":""},
  {"id":6,"name":"Detox\nCalendar","icon":"medication","route":"/detox","description":"Jadwal program detox kesehatan.","price":""},
  {"id":7,"name":"Educational\nTips","icon":"book","route":"/service/7","description":"Edukasi kesehatan dari para ahli BSI.","price":""}
]
```

**Format JSON:**
- `id`: ID unik untuk service (integer)
- `name`: Nama service (gunakan `\n` untuk baris baru jika perlu)
- `icon`: Nama icon (lihat daftar icon yang tersedia di ServiceGrid)
- `route`: Route navigasi untuk service
- `description`: Deskripsi singkat service
- `price`: Harga service (kosongkan string jika tidak ada harga)

### Langkah 2: Tambahkan Icon Mapping ke ServiceGrid

**File:** `lib/widgets/service_grid.dart`

Tambahkan case baru di method `_getIconData` untuk icon yang digunakan:

```dart
IconData _getIconData(String iconName) {
  switch (iconName.toLowerCase()) {
    case 'microscope':
      return Icons.science;
    case 'test_tube':
      return Icons.biotech;
    case 'iv_bag':
      return Icons.medical_services;
    case 'calendar':
      return Icons.calendar_today;
    case 'chat':
      return Icons.chat_bubble_outline;
    case 'book':
      return Icons.menu_book;
    case 'medication':  // Tambahkan ini
      return Icons.medication;
    default:
      return Icons.star;
  }
}
```

**Icon yang tersedia:**
- `microscope` → Icons.science
- `test_tube` → Icons.biotech
- `iv_bag` → Icons.medical_services
- `calendar` → Icons.calendar_today
- `chat` → Icons.chat_bubble_outline
- `book` → Icons.menu_book
- `medication` → Icons.medication
- Bisa tambahkan icon lain sesuai kebutuhan

### Langkah 3: Tidak Perlu Perubahan Lain

Tidak perlu mengubah:
- Model (ServiceModel sudah ada dan fleksibel)
- Home screen (sudah memuat semua services dari JSON)
- Widget lain (ServiceGrid otomatis menampilkan semua services)

## Checklist Penambahan Service

- [ ] Tambahkan entry baru di `assets/data/services.json`
- [ ] Tambahkan icon mapping di `lib/widgets/service_grid.dart` method `_getIconData`
- [ ] Test dengan `flutter run`
- [ ] Verifikasi service muncul di grid

## Contoh Lengkap: Menambahkan Detox Calendar

### 1. Edit services.json
```json
{"id":6,"name":"Detox\nCalendar","icon":"medication","route":"/detox","description":"Jadwal program detox kesehatan.","price":""}
```

### 2. Edit service_grid.dart
```dart
case 'medication':
  return Icons.medication;
```

### 3. Hot reload
Service akan otomatis muncul di ServiceGrid bersama layanan lainnya.

## Tips Best Practices

1. **Naming Convention**: Gunakan snake_case untuk nama icon di JSON
2. **Icon Selection**: Pilih icon yang relevan dengan fungsi service
3. **Price**: Kosongkan field price jika service tidak memiliki harga
4. **Description**: Buat deskripsi singkat dan jelas
5. **Route**: Pastikan route sesuai dengan navigasi aplikasi

## Icon Material Icons yang Umum

Berikut beberapa icon yang sering digunakan untuk layanan kesehatan:
- `Icons.medical_services` - Layanan medis
- `Icons.medication` - Obat/suplemen
- `Icons.science` - Laboratorium
- `Icons.biotech` - Tes medis
- `Icons.calendar_today` - Janji temu
- `Icons.chat_bubble_outline` - Chat/komunikasi
- `Icons.menu_book` - Edukasi
- `Icons.spa` - Wellness
- `Icons.accessibility_new` - Kesehatan fisik
- `Icons.favorite` - Kesehatan jantung
- `Icons.psychology` - Kesehatan mental

## Testing

Setelah menambahkan service baru, jalankan:

```bash
# Hot reload (jika aplikasi sudah berjalan)
# Tekan 'r' di terminal flutter

# Atau restart aplikasi
flutter run -d chrome
```

Verifikasi:
- Service baru muncul di ServiceGrid
- Icon ditampilkan dengan benar
- Nama dan deskripsi terbaca dengan jelas
- Tidak ada error di console
