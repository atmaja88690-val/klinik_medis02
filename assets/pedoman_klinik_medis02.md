# PEDOMAN KLINIK MEDIS 02

> Dokumen pedoman tunggal untuk pengembangan project **klinik_medis02** (Flutter)
> + backend **Laravel 11 REST API** + **Admin Dashboard Web (Blade + Bootstrap 5)**
> + konfigurasi **API path dinamis multiplatform** (web, android emulator, device LAN, production).
>
> Repo Flutter referensi: https://github.com/atmaja88690-val/klinik_medis02.git
> Folder Laravel: `klinik_medis_api/` (sejajar di workspace yang sama)

---

## Daftar Isi

1. [Prasyarat & Instalasi Tools](#1-prasyarat--instalasi-tools)
2. [Clone & Setup Project Flutter](#2-clone--setup-project-flutter)
3. [Bagian 1 — Menambah Service & Icon Baru](#3-bagian-1--menambah-service--icon-baru)
4. [Bagian 2 — Edit / Pindah Fitur (Detox, Book Appointment) ke Widget Navigasi Terkait](#4-bagian-2--edit--pindah-fitur-detox-book-appointment-ke-widget-navigasi-terkait)
5. [Bagian 3 — Pindahkan Account Profile ke Widget Profile (dengan tombol Logout)](#5-bagian-3--pindahkan-account-profile-ke-widget-profile-dengan-tombol-logout)
6. [Bagian 4 — Integrasi REST API Laravel 11 (`klinik_medis_api/`)](#6-bagian-4--integrasi-rest-api-laravel-11-klinik_medis_api)
7. [Bagian 5 — Admin Dashboard Web (Laravel 11 + Blade + Bootstrap 5)](#7-bagian-5--admin-dashboard-web-laravel-11--blade--bootstrap-5)
8. [Bagian 6 — Konfigurasi API Path Dinamis Multiplatform](#8-bagian-6--konfigurasi-api-path-dinamis-multiplatform)
9. [Alur Kerja Git & Workspace (Monorepo Logis Dua Project)](#9-alur-kerja-git--workspace-monorepo-logis-dua-project)
10. [Troubleshooting & FAQ](#10-troubleshooting--faq)

---

## 1. Prasyarat & Instalasi Tools

### 1.1 Tools wajib (versi minimum)

| Tool          | Versi minimum | Cek versi                |
|---------------|---------------|--------------------------|
| Git           | 2.40          | `git --version`          |
| Flutter SDK   | 3.22.x        | `flutter --version`      |
| Dart          | 3.4.x         | `dart --version`         |
| Android Studio| Hedgehog+     | dari Settings > About    |
| JDK           | 17            | `java -version`          |
| PHP           | 8.2 atau 8.3  | `php -v`                 |
| Composer      | 2.7           | `composer --version`     |
| MySQL/MariaDB | 8.x / 10.6+   | `mysql --version`        |
| Node.js       | 20 LTS (opt.) | `node -v`                |

### 1.2 Cek environment (Linux/macOS/Windows)

```bash
# Cek semua tool sekaligus
git --version && flutter --version && php -v && composer --version && mysql --version
flutter doctor -v
```

### 1.3 Install perintah cepat

**Windows (winget):**
```powershell
winget install Git.Git
winget install OpenJS.NodeJS.LTS
winget install --id Oracle.JDK.17
# Flutter: download manual dari https://docs.flutter.dev/get-started/install/windows
# PHP & Composer: pakai Laragon (https://laragon.org) atau XAMPP
```

**macOS (brew):**
```bash
brew install git php@8.3 composer mysql node
brew install --cask flutter android-studio
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install -y git curl unzip php8.3 php8.3-{cli,mbstring,xml,mysql,zip,curl,gd,bcmath} mysql-server
curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer
# Flutter:
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc && source ~/.bashrc
```

---

## 2. Clone & Setup Project Flutter

### 2.1 Alur

1. Tentukan folder kerja (mis. `~/projects/klinik`).
2. Clone repo `klinik_medis02`.
3. Resolve dependency.
4. Jalankan analisis statis.
5. Run di emulator / web untuk smoke test.

### 2.2 Perintah terminal

```bash
# 1) Buat folder kerja
mkdir -p ~/projects/klinik && cd ~/projects/klinik

# 2) Clone repo Flutter
git clone https://github.com/atmaja88690-val/klinik_medis02.git
cd klinik_medis02

# 3) Tambah dependencies inti yang dibutuhkan integrasi API
flutter pub add dio flutter_secure_storage shared_preferences intl
flutter pub add cached_network_image image_picker
flutter pub add --dev build_runner json_serializable

# 4) Resolve & analisis
flutter pub get
flutter analyze

# 5) Daftar device & run
flutter devices
flutter run -d chrome           # web
# atau:
flutter run -d emulator-5554    # android emulator
```

### 2.3 Struktur folder Flutter yang direkomendasikan

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/
│   │   ├── api_config.dart        # base URL multiplatform
│   │   └── env.dart               # baca --dart-define
│   ├── network/
│   │   ├── api_client.dart        # Dio + interceptor
│   │   └── api_exception.dart
│   ├── storage/
│   │   └── token_storage.dart     # flutter_secure_storage
│   └── utils/
├── data/
│   ├── models/                    # auth, user, service, doctor, appointment, detox, article, notification
│   └── repositories/
├── features/
│   ├── auth/                      # login, register, forgot
│   ├── home/                      # services grid, banner, dsb.
│   ├── services/                  # detail per service
│   ├── doctors/
│   ├── appointment/               # book, list, detail
│   ├── detox/                     # programs, enroll
│   ├── articles/
│   ├── notifications/
│   └── profile/                   # account profile + logout
└── shared/
    └── widgets/                   # reusable widget
```

---

## 3. Bagian 1 — Menambah Service & Icon Baru

### 3.1 Tujuan

Menambah item **Service** baru (misal “Vaksinasi”) beserta **icon** di grid Home, dan memastikan datanya konsisten antara aset lokal (jika hardcode) maupun datasource API.

### 3.2 Alur sistematis

1. Tambahkan asset icon (svg/png) di `assets/icons/`.
2. Daftarkan asset di `pubspec.yaml`.
3. Tambahkan model & data baru di list service.
4. (Opsional) Sinkronkan dengan tabel `services` di backend.
5. Hot reload / restart Flutter.

### 3.3 Perintah terminal

```bash
cd ~/projects/klinik/klinik_medis02

# 1) Tambah asset icon
mkdir -p assets/icons
cp /path/ke/icon-vaksinasi.svg assets/icons/vaksinasi.svg

# 2) Cari file home yang menampilkan grid services (lokasi bisa berbeda per repo)
grep -RIn "services" lib/features/home   2>/dev/null || true
grep -RIn "ServiceItem\|ServiceCard\|services_list" lib

# 3) Edit pubspec.yaml untuk register asset, lalu:
flutter pub get

# 4) Restart penuh (hot-restart, bukan hot-reload, agar asset baru terbaca)
flutter run
```

### 3.4 Edit `pubspec.yaml` (snippet)

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/icons/
    - assets/images/
```

### 3.5 Contoh model `Service` (`lib/data/models/service_model.dart`)

```dart
class ServiceModel {
  final int id;
  final String name;
  final String iconAsset;     // path lokal ATAU URL dari API
  final String? description;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.iconAsset,
    this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as int,
        name: json['name'] as String,
        iconAsset: (json['icon_url'] ?? json['icon']) as String,
        description: json['description'] as String?,
      );
}
```

### 3.6 Contoh menambah item baru di list lokal

```dart
// lib/features/home/data/local_services.dart
final List<ServiceModel> kLocalServices = [
  ServiceModel(id: 1, name: 'Konsultasi', iconAsset: 'assets/icons/konsultasi.svg'),
  ServiceModel(id: 2, name: 'Detox',       iconAsset: 'assets/icons/detox.svg'),
  ServiceModel(id: 3, name: 'Appointment', iconAsset: 'assets/icons/appointment.svg'),
  // BARU:
  ServiceModel(id: 4, name: 'Vaksinasi',   iconAsset: 'assets/icons/vaksinasi.svg'),
];
```

### 3.7 Contoh widget `ServiceCard` (kalau belum ada / ingin dirombak)

```dart
class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAsset = service.iconAsset.startsWith('assets/');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isAsset
                ? Image.asset(service.iconAsset, width: 40, height: 40)
                : Image.network(service.iconAsset, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(service.name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
```

### 3.8 Verifikasi

- Buka Home → icon baru muncul di grid.
- Tap icon → navigasi ke screen detail (`/services/:id`).

---

## 4. Bagian 2 — Edit / Pindah Fitur (Detox, Book Appointment) ke Widget Navigasi Terkait

### 4.1 Tujuan

Memindahkan tombol/menu **Edit Detox** dan **Edit Book Appointment** dari lokasi semula ke **widget navigasi** lain yang lebih relevan (mis. dari Home Quick Action ke `BottomNavigationBar` tab tertentu, atau ke `Drawer`).

### 4.2 Alur sistematis

1. Identifikasi widget navigasi tujuan (BottomNav, Drawer, TabBar, FAB).
2. Cari pemanggil (caller) lama menggunakan `grep`.
3. Pindahkan trigger ke widget navigasi tujuan.
4. Pastikan route/page tujuan tetap dapat diakses.
5. Hapus trigger lama (jika tidak diperlukan).

### 4.3 Perintah terminal investigasi

```bash
# Cari semua referensi fitur Detox
grep -RIn "Detox\|DetoxScreen\|/detox" lib

# Cari semua referensi Book Appointment
grep -RIn "BookAppointment\|/appointment\|book_appointment" lib

# Cari widget navigasi yang ada
grep -RIn "BottomNavigationBar\|NavigationBar\|Drawer\|TabBar" lib
```

### 4.4 Contoh: tambahkan ke `BottomNavigationBar`

```dart
// lib/features/main/main_shell.dart
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pages = const [
    HomeScreen(),
    AppointmentScreen(),  // book appointment di tab 2
    DetoxScreen(),        // detox di tab 3
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),       selectedIcon: Icon(Icons.home),       label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_outlined),      selectedIcon: Icon(Icons.event),      label: 'Appointment'),
          NavigationDestination(icon: Icon(Icons.spa_outlined),        selectedIcon: Icon(Icons.spa),        label: 'Detox'),
          NavigationDestination(icon: Icon(Icons.person_outline),      selectedIcon: Icon(Icons.person),     label: 'Profile'),
        ],
      ),
    );
  }
}
```

### 4.5 Contoh: pindahkan tombol “Edit Detox” ke detail Detox (bukan Home)

```dart
// Sebelumnya di home_screen.dart:
//   FloatingActionButton(onPressed: () => Navigator.pushNamed(ctx, '/detox/edit'))
// Hapus dari Home, lalu tambahkan di DetoxDetailScreen:

class DetoxDetailScreen extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Detox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/detox/edit'),
          ),
        ],
      ),
      body: /* ... */,
    );
  }
}
```

### 4.6 Contoh: pindahkan “Book Appointment” ke FAB pada tab Appointment

```dart
class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: const AppointmentList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Book'),
        onPressed: () => Navigator.pushNamed(context, '/appointment/book'),
      ),
    );
  }
}
```

### 4.7 Verifikasi

```bash
flutter analyze
flutter test    # bila ada test
flutter run
```

- Tidak ada warning “unused import” pada file lama.
- Tab/Drawer baru bisa membuka screen tujuan.
- Trigger lama tidak ada lagi (cek dengan `grep -RIn "/detox/edit" lib`).

---

## 5. Bagian 3 — Pindahkan Account Profile ke Widget Profile (dengan tombol Logout)

### 5.1 Tujuan

Memindahkan **Account Profile** (data nama, email, foto, edit profile) ke widget `ProfileScreen` yang juga berisi tombol **Logout**, sehingga user mengakses semuanya dalam satu tempat.

### 5.2 Alur sistematis

1. Buat / pakai `ProfileScreen` di tab Profile.
2. Pindahkan section Account ke dalam `ProfileScreen`.
3. Tambahkan tombol Logout (memanggil `AuthService.logout()`).
4. Setelah logout: hapus token, kembali ke `LoginScreen`.

### 5.3 Contoh `ProfileScreen`

```dart
// lib/features/profile/profile_screen.dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Section Account Profile (dipindahkan ke sini) =====
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user?.name ?? '-'),
              subtitle: Text(user?.email ?? '-'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ===== Menu lain =====
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ubah Password'),
            onTap: () => Navigator.pushNamed(context, '/profile/password'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi'),
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),

          const Divider(height: 32),

          // ===== Tombol Logout =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin keluar?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Logout')),
                    ],
                  ),
                );
                if (ok == true) {
                  await context.read<AuthController>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### 5.4 Hapus duplikasi Account Profile dari tempat lama

```bash
grep -RIn "AccountProfile\|account_profile" lib
# Hapus widget / tombol lama yang menavigasi ke Account Profile dari Drawer / Home.
```

### 5.5 Verifikasi

- Tab Profile menampilkan nama, email, avatar, tombol Edit, dan tombol Logout.
- Tap Logout → konfirmasi → token hilang (`flutter_secure_storage`) → balik ke Login.
- `AccountProfileScreen` lama tidak muncul lagi di navigasi.

---

## 6. Bagian 4 — Integrasi REST API Laravel 11 (`klinik_medis_api/`)

### 6.1 Tujuan

Membuat backend Laravel 11 yang lengkap (Auth Sanctum, Profile, Services, Doctors, Appointments, Detox, Articles, Notifications, File Upload), lalu mengintegrasikannya ke Flutter.

### 6.2 Struktur folder hasil scaffolding

```
klinik_medis_api/
├── app/
│   ├── Models/                    User, Service, Doctor, Appointment,
│   │                              DetoxProgram, DetoxEnrollment, Article, Notification
│   └── Http/
│       ├── Controllers/Api/       (8 controller mobile)
│       ├── Controllers/Admin/     (7 controller dashboard)
│       ├── Middleware/            EnsureUserIsAdmin, ForceJsonResponse
│       ├── Requests/              FormRequests
│       └── Resources/             API JSON Resources
├── routes/
│   ├── api.php                    /api/v1/*
│   ├── web.php                    /admin/*
│   └── auth.php                   /login admin
├── database/
│   ├── migrations/
│   └── seeders/
├── resources/views/               Blade + Bootstrap 5 (admin dashboard)
├── config/{cors,sanctum}.php
├── public/
└── .env.example
```

### 6.3 Perintah setup awal

```bash
# 1) Pastikan kamu di workspace yang sama dengan project Flutter
cd ~/projects/klinik

# 2) Clone / scaffolding Laravel
composer create-project laravel/laravel klinik_medis_api "11.*"
cd klinik_medis_api

# 3) Install package wajib
composer require laravel/sanctum intervention/image
php artisan install:api          # mendaftarkan routes/api.php otomatis di Laravel 11

# 4) Salin .env dan generate key
cp .env.example .env
php artisan key:generate

# 5) Edit .env (DB, APP_URL, SANCTUM_STATEFUL_DOMAINS)
#   APP_URL=http://127.0.0.1:8000
#   DB_DATABASE=klinik_medis
#   SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1,localhost:5173,127.0.0.1:8000

# 6) Buat database, migrate + seed
mysql -u root -p -e "CREATE DATABASE klinik_medis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
php artisan migrate --seed

# 7) Storage symlink (untuk upload avatar/icon)
php artisan storage:link

# 8) Jalankan server dengan binding 0.0.0.0 (agar bisa diakses dari device LAN)
php artisan serve --host=0.0.0.0 --port=8000
```

### 6.4 Daftar endpoint REST API (v1)

> Base URL: `{API_URL}` (lihat Bagian 6).
> Header umum: `Accept: application/json`, `Authorization: Bearer {token}` (kecuali Auth).

| Method | Endpoint                                    | Auth | Keterangan                          |
|--------|---------------------------------------------|------|-------------------------------------|
| POST   | `/api/v1/auth/register`                     | -    | Register user baru                  |
| POST   | `/api/v1/auth/login`                        | -    | Login → token                       |
| POST   | `/api/v1/auth/logout`                       | yes  | Revoke token                        |
| GET    | `/api/v1/auth/me`                           | yes  | Profil user terautentikasi          |
| GET    | `/api/v1/profile`                           | yes  | Detail profil                       |
| PUT    | `/api/v1/profile`                           | yes  | Update nama/phone/dob/gender        |
| POST   | `/api/v1/profile/avatar`                    | yes  | Upload avatar (multipart)           |
| PUT    | `/api/v1/profile/password`                  | yes  | Ubah password                       |
| GET    | `/api/v1/services`                          | -    | List semua service + icon           |
| GET    | `/api/v1/services/{id}`                     | -    | Detail service                      |
| GET    | `/api/v1/doctors`                           | -    | List dokter (filter `?service_id`)  |
| GET    | `/api/v1/doctors/{id}`                      | -    | Detail dokter                       |
| GET    | `/api/v1/appointments`                      | yes  | Riwayat appointment user            |
| POST   | `/api/v1/appointments`                      | yes  | Buat appointment baru               |
| GET    | `/api/v1/appointments/{id}`                 | yes  | Detail                              |
| POST   | `/api/v1/appointments/{id}/cancel`          | yes  | Batalkan                            |
| GET    | `/api/v1/detox/programs`                    | -    | List program detox                  |
| GET    | `/api/v1/detox/programs/{id}`               | -    | Detail program                      |
| POST   | `/api/v1/detox/programs/{id}/enroll`        | yes  | Daftar program detox                |
| GET    | `/api/v1/detox/enrollments`                 | yes  | Riwayat enrollment user             |
| GET    | `/api/v1/articles`                          | -    | List artikel kesehatan              |
| GET    | `/api/v1/articles/{slug}`                   | -    | Detail artikel                      |
| GET    | `/api/v1/notifications`                     | yes  | List notifikasi                     |
| POST   | `/api/v1/notifications/{id}/read`           | yes  | Tandai dibaca                       |
| POST   | `/api/v1/notifications/read-all`            | yes  | Tandai semua dibaca                 |

### 6.5 Format respons standar

```json
{
  "success": true,
  "message": "OK",
  "data": { /* payload */ },
  "meta":  { "page": 1, "per_page": 15, "total": 42 }
}
```

Error:
```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": { "email": ["Email sudah terdaftar"] }
}
```

### 6.6 Test cepat dengan curl

```bash
# Register
curl -s -X POST http://127.0.0.1:8000/api/v1/auth/register \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"name":"Budi","email":"budi@mail.com","password":"password","password_confirmation":"password"}' | jq

# Login
TOKEN=$(curl -s -X POST http://127.0.0.1:8000/api/v1/auth/login \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"email":"budi@mail.com","password":"password"}' | jq -r '.data.token')

# Akses route protected
curl -s http://127.0.0.1:8000/api/v1/auth/me \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' | jq

# List services (publik)
curl -s http://127.0.0.1:8000/api/v1/services -H 'Accept: application/json' | jq
```

### 6.7 Integrasi di Flutter

`lib/core/network/api_client.dart`:
```dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient._() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) {
        // map ke ApiException
        handler.next(e);
      },
    ));
  }
  static final ApiClient instance = ApiClient._();
  late final Dio dio;
}
```

`lib/data/repositories/auth_repository.dart`:
```dart
class AuthRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final data = res.data['data'];
    await TokenStorage.write(data['token'] as String);
    return UserModel.fromJson(data['user']);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
    await TokenStorage.clear();
  }
}
```

---

## 7. Bagian 5 — Admin Dashboard Web (Laravel 11 + Blade + Bootstrap 5)

### 7.1 Tujuan

Membuat dashboard admin **tanpa framework JavaScript** (tanpa React, Vue, Alpine optional). Hanya Blade + Bootstrap 5 + Chart.js (vanilla, via CDN).

### 7.2 Alur sistematis

1. Buat layout `layouts/admin.blade.php` (Bootstrap 5 CDN).
2. Buat halaman login admin (`auth/login.blade.php`).
3. Middleware `EnsureUserIsAdmin` melindungi semua route `/admin/*`.
4. Halaman dashboard menampilkan KPI cards + chart appointment per bulan.
5. CRUD untuk Users, Services, Doctors, Appointments, Detox, Articles.
6. Flash message + Bootstrap Alert.

### 7.3 Perintah terminal

```bash
cd ~/projects/klinik/klinik_medis_api

# Buat controller admin
php artisan make:controller Admin/DashboardController
php artisan make:controller Admin/UserController       --resource
php artisan make:controller Admin/ServiceController    --resource
php artisan make:controller Admin/DoctorController     --resource
php artisan make:controller Admin/AppointmentController --resource
php artisan make:controller Admin/DetoxController      --resource
php artisan make:controller Admin/ArticleController    --resource

# Buat middleware
php artisan make:middleware EnsureUserIsAdmin

# Lihat semua route admin
php artisan route:list --path=admin

# Jalankan
php artisan serve
# Buka: http://127.0.0.1:8000/admin/login
#   email:    admin@klinik.test
#   password: password   (dibuat oleh AdminUserSeeder)
```

### 7.4 Blade layout (Bootstrap 5 dari CDN)

`resources/views/layouts/admin.blade.php` sudah disertakan dalam scaffolding folder `klinik_medis_api/resources/views/layouts/admin.blade.php`. Lihat file tersebut untuk source lengkapnya.

### 7.5 Halaman dashboard

Berisi:
- **4 KPI cards**: total user, total appointment hari ini, total appointment bulan ini, total enrollment detox.
- **Chart line** appointment per bulan (Chart.js dari CDN, `<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>`).
- **Tabel** 5 appointment terbaru.

### 7.6 Verifikasi

- `http://127.0.0.1:8000/admin/login` muncul form login.
- Login admin → redirect ke `/admin` → lihat KPI + chart.
- Sidebar berisi menu: Dashboard, Users, Services, Doctors, Appointments, Detox, Articles, Logout.

---

## 8. Bagian 6 — Konfigurasi API Path Dinamis Multiplatform

### 8.1 Tujuan

Satu codebase Flutter yang **otomatis** memilih `baseUrl` sesuai:

- **Web** (Chrome) → `http://localhost:8000/api/v1`
- **Android Emulator** → `http://10.0.2.2:8000/api/v1`
- **iOS Simulator** → `http://127.0.0.1:8000/api/v1`
- **Device fisik di LAN** → `http://192.168.x.x:8000/api/v1`
- **Production** → `https://api.klinik-medis.com/api/v1`

Strategi: **Flavors via `--dart-define`** (`ENV`, `API_URL`) + **`ApiConfig` class platform-aware** sebagai fallback bila `API_URL` tidak diisi.

### 8.2 File `lib/core/config/env.dart`

```dart
class Env {
  static const String env =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  /// Boleh dikosongkan; bila kosong, ApiConfig.baseUrl akan auto-detect.
  static const String apiUrlOverride =
      String.fromEnvironment('API_URL', defaultValue: '');

  static bool get isProd => env == 'prod';
  static bool get isStaging => env == 'staging';
  static bool get isDev => env == 'dev';
}
```

### 8.3 File `lib/core/config/api_config.dart`

```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'env.dart';

class ApiConfig {
  static const _prodUrl    = 'https://api.klinik-medis.com/api/v1';
  static const _stagingUrl = 'https://staging-api.klinik-medis.com/api/v1';

  /// Base URL yang dipakai seluruh app.
  static String get baseUrl {
    // 1) Override eksplisit via --dart-define=API_URL=...
    if (Env.apiUrlOverride.isNotEmpty) return Env.apiUrlOverride;

    // 2) Production / staging
    if (Env.isProd)    return _prodUrl;
    if (Env.isStaging) return _stagingUrl;

    // 3) Dev — auto-detect platform
    if (kIsWeb)               return 'http://localhost:8000/api/v1';
    if (Platform.isAndroid)   return 'http://10.0.2.2:8000/api/v1';
    if (Platform.isIOS)       return 'http://127.0.0.1:8000/api/v1';
    return 'http://localhost:8000/api/v1';
  }
}
```

### 8.4 Perintah run sesuai platform/lingkungan

```bash
# === DEV ===

# Web (Chrome)
flutter run -d chrome

# Android Emulator (otomatis 10.0.2.2)
flutter run -d emulator-5554

# Android Device fisik di LAN — set IP host PC
# Cek dulu IP LAN host:
#   Linux/Mac:  ip addr show | grep "inet "
#   Windows:    ipconfig | findstr IPv4
flutter run --dart-define=API_URL=http://192.168.1.10:8000/api/v1

# iOS Simulator (otomatis 127.0.0.1)
flutter run -d "iPhone 15"

# === STAGING / PROD ===
flutter run --dart-define=ENV=staging
flutter build apk     --release --dart-define=ENV=prod
flutter build web     --release --dart-define=ENV=prod
flutter build appbundle --release --dart-define=ENV=prod
```

### 8.5 Server side (Laravel) — listen ke semua interface

```bash
# WAJIB pakai 0.0.0.0 supaya device LAN bisa konek
php artisan serve --host=0.0.0.0 --port=8000

# Bila port bentrok:
php artisan serve --host=0.0.0.0 --port=8080
```

### 8.6 CORS config (`config/cors.php`)

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],     // dev; di prod ganti list spesifik
    'allowed_origins_patterns' => [
        '/^http:\/\/localhost(:\d+)?$/',
        '/^http:\/\/127\.0\.0\.1(:\d+)?$/',
        '/^http:\/\/10\.0\.2\.2(:\d+)?$/',
        '/^http:\/\/192\.168\.\d+\.\d+(:\d+)?$/',
    ],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 8.7 Verifikasi multiplatform

| Platform           | Perintah                                                                 | Expected                  |
|--------------------|--------------------------------------------------------------------------|---------------------------|
| Web                | `flutter run -d chrome`                                                  | hit `localhost:8000`      |
| Android Emulator   | `flutter run -d emulator-5554`                                           | hit `10.0.2.2:8000`       |
| iOS Simulator      | `flutter run -d "iPhone 15"`                                             | hit `127.0.0.1:8000`      |
| Android LAN        | `flutter run --dart-define=API_URL=http://192.168.1.10:8000/api/v1`      | hit IP LAN                |
| Production build   | `flutter build apk --release --dart-define=ENV=prod`                     | hit domain prod           |

---

## 9. Alur Kerja Git & Workspace (Monorepo Logis Dua Project)

### 9.1 Layout workspace

```
~/projects/klinik/
├── klinik_medis02/        # Flutter app (repo: atmaja88690-val/klinik_medis02)
└── klinik_medis_api/      # Laravel 11 + Admin Dashboard (repo terpisah)
```

> Keduanya **repo Git independen** untuk memudahkan CI/CD masing-masing.
> Workspace ini (folder Enter React) tidak mengikat keduanya — hanya menampung dokumentasi `docs/PEDOMAN.md`.

### 9.2 Init repo Laravel pertama kali

```bash
cd ~/projects/klinik/klinik_medis_api
git init
git checkout -b main
echo ".env"            >> .gitignore   # sudah default Laravel
echo "/vendor"         >> .gitignore
echo "/storage/*.key"  >> .gitignore
git add .
git commit -m "init: laravel 11 api + admin dashboard"
git remote add origin git@github.com:atmaja88690-val/klinik_medis_api.git
git push -u origin main
```

### 9.3 Branch & convention

- `main`        — produksi (protected)
- `develop`     — integrasi
- `feature/*`   — fitur baru
- `hotfix/*`    — perbaikan urgent

Commit style: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:` (Conventional Commits).

### 9.4 Sinkronisasi Flutter ↔ API (script bantu)

```bash
# scripts/dev-up.sh
#!/usr/bin/env bash
set -e
( cd klinik_medis_api && php artisan serve --host=0.0.0.0 --port=8000 ) &
( cd klinik_medis02   && flutter run -d chrome )
wait
```

```bash
chmod +x scripts/dev-up.sh
./scripts/dev-up.sh
```

---

## 10. Troubleshooting & FAQ

| Masalah                                         | Penyebab umum                                    | Solusi                                                                 |
|------------------------------------------------|--------------------------------------------------|------------------------------------------------------------------------|
| `Connection refused` di Android Emulator        | Pakai `localhost`, harusnya `10.0.2.2`           | Hapus override `API_URL`, biarkan ApiConfig auto-detect                |
| `Connection refused` di Device fisik            | Server Laravel listen `127.0.0.1` saja           | Jalankan `php artisan serve --host=0.0.0.0 --port=8000`                |
| `CORS blocked` dari Flutter Web                 | Origin tidak diizinkan                           | Update `config/cors.php` `allowed_origins_patterns`                    |
| `419 CSRF token mismatch` di admin web          | Session cookie SameSite                          | Pastikan akses via domain yang sama dgn `SANCTUM_STATEFUL_DOMAINS`     |
| `401 Unauthenticated` walau token ada           | Header tidak terkirim / `Bearer` salah           | Cek interceptor Dio: `Authorization: Bearer <token>`                   |
| Asset icon Flutter tidak muncul                 | `pubspec.yaml` belum dirun                       | `flutter pub get` lalu `flutter run` (full restart)                    |
| `SQLSTATE[HY000] [2002]`                        | MySQL belum jalan / kredensial salah             | `sudo service mysql start`, cek `.env`                                 |
| Migration error `Specified key was too long`    | Default charset/collation                        | Tambahkan `Schema::defaultStringLength(191);` di `AppServiceProvider`  |
| Bootstrap CDN tidak load                        | Offline / firewall                               | Download Bootstrap, taruh di `public/assets/css/bootstrap.min.css`     |
| Upload avatar gagal `413`                       | Limit upload PHP                                 | `upload_max_filesize=10M`, `post_max_size=10M` di `php.ini`            |

### 10.1 Checklist akhir sebelum demo

- [ ] `php artisan migrate:fresh --seed` jalan tanpa error.
- [ ] `php artisan route:list` menunjukkan semua route v1 + admin.
- [ ] `curl /api/v1/services` return JSON list non-empty.
- [ ] Login admin web sukses, dashboard muncul dengan chart.
- [ ] Flutter web bisa login & lihat services.
- [ ] Flutter android emulator bisa login & lihat services.
- [ ] Flutter device LAN bisa login (dengan `--dart-define=API_URL=...`).
- [ ] Tombol Logout di Profile berfungsi: token hilang, kembali ke Login.

---

**Akhir dokumen.** Untuk update / perbaikan, edit file `docs/PEDOMAN.md` ini langsung.
