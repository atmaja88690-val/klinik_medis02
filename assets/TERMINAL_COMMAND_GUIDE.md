# Terminal Command Guide - BSI Clinic Project

Dokumentasi lengkap untuk perintah terminal, alur kerja, dan pengembangan fitur pada project Klinik BSI (Flutter + Laravel).

---

## Table of Contents

1. [Struktur Project & Workspace](#1-struktur-project--workspace)
2. [Menambahkan Service & Icon](#2-menambahkan-service--icon)
3. [Edit/Menambahkan Fitur dengan Navigasi](#3-editmenambahkan-fitur-dengan-navigasi)
4. [Edit Account Profile dengan Logout](#4-edit-account-profile-dengan-logout)
5. [Integrasi REST API Laravel 11](#5-integrasi-rest-api-laravel-11)
6. [Admin Dashboard Laravel 11 + Bootstrap](#6-admin-dashboard-laravel-11--bootstrap)
7. [Dynamic API Paths Multiplatform](#7-dynamic-api-paths-multiplatform)

---

## 1. Struktur Project & Workspace

### 1.1 Struktur Folder Workspace

```
c:\xampp\htdocs\projects\clinic01/
├── mobile_app/              # Flutter Application
│   ├── lib/
│   │   ├── models/         # Data models
│   │   ├── widgets/        # Reusable widgets
│   │   ├── screens/        # Screen pages
│   │   │   ├── home/
│   │   │   ├── chat/
│   │   │   ├── profile/
│   │   │   └── ...
│   │   ├── services/       # API services
│   │   └── main.dart
│   ├── assets/
│   │   ├── images/
│   │   ├── data/           # JSON data files
│   │   └── icons/
│   └── pubspec.yaml
│
├── backend_laravel/         # Laravel 11 API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   │   ├── Api/
│   │   │   │   └── Admin/
│   │   │   └── Middleware/
│   │   ├── Models/
│   │   └── Services/
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── routes/
│   │   ├── api.php
│   │   └── web.php
│   ├── resources/
│   │   └── views/          # Admin Dashboard Blade
│   └── config/
│
└── TERMINAL_COMMAND_GUIDE.md
```

### 1.2 Command Navigasi Dasar

```powershell
# Navigasi ke project Flutter
cd c:\xampp\htdocs\projects\clinic01\mobile_app

# Navigasi ke project Laravel
cd c:\xampp\htdocs\projects\clinic01\backend_laravel

# Kembali ke root workspace
cd c:\xampp\htdocs\projects\clinic01

# List directory
ls                          # PowerShell
dir                         # CMD

# Buka folder di Explorer
explorer .
```

---

## 2. Menambahkan Service & Icon

### 2.1 Alur Penambahan Service Baru

**Langkah 1: Update services.json**

```powershell
# Buka file services.json
code c:\xampp\htdocs\projects\clinic01\mobile_app\assets\data\services.json
```

Format entry baru:
```json
{
  "id": 9,
  "name": "New\nService",
  "icon": "icon_name",
  "route": "/route-name",
  "description": "Deskripsi layanan.",
  "price": ""
}
```

**Langkah 2: Tambahkan Icon Mapping**

```powershell
# Buka service_grid.dart
code c:\xampp\htdocs\projects\clinic01\mobile_app\lib\widgets\service_grid.dart
```

Tambahkan case di method `_getIconData`:
```dart
case 'icon_name':
  return Icons.icon_name;
```

**Langkah 3: Test Perubahan**

```powershell
# Jalankan Flutter di Chrome
flutter run -d chrome

# Hot reload (tekan r di terminal)
r

# Hot restart (tekan R di terminal)
R
```

### 2.2 Command Terminal Lengkap

```powershell
# 1. Navigasi ke project Flutter
cd c:\xampp\htdocs\projects\clinic01\mobile_app

# 2. Jalankan aplikasi untuk testing
flutter run -d chrome

# 3. Jika ada error dependency
flutter clean
flutter pub get
flutter run -d chrome

# 4. Build APK (untuk testing Android)
flutter build apk --debug

# 5. Build Web (untuk deployment)
flutter build web
```

### 2.3 Material Icons yang Tersedia

| Icon Name | Flutter Icon | Kategori |
|-----------|--------------|----------|
| `science` | Icons.science | Lab/Mikroskop |
| `biotech` | Icons.biotech | Biotech |
| `vaccines` | Icons.vaccines | Jarum/Vaksin |
| `water_drop` | Icons.water_drop | Infus/Cairan |
| `calendar_month` | Icons.calendar_month | Kalender |
| `chat_bubble` | Icons.chat_bubble | Chat |
| `person` | Icons.person | Profil |
| `logout` | Icons.logout | Logout |
| `medication` | Icons.medication | Obat |
| `local_hospital` | Icons.local_hospital | Rumah Sakit |
| `bloodtype` | Icons.bloodtype | Darah |
| `healing` | Icons.healing | Pengobatan |

---

## 3. Edit/Menambahkan Fitur dengan Navigasi

### 3.1 Alur Menambahkan Fitur Baru (Contoh: Detox Detail)

**Step 1: Buat Screen/Widget Baru**

```powershell
# Buat folder screen baru
mkdir c:\xampp\htdocs\projects\clinic01\mobile_app\lib\screens\detox

# Buat file screen
type nul > c:\xampp\htdocs\projects\clinic01\mobile_app\lib\screens\detox\detox_detail_screen.dart
```

**Step 2: Isi Template Screen**

```dart
// lib/screens/detox/detox_detail_screen.dart
import 'package:flutter/material.dart';

class DetoxDetailScreen extends StatelessWidget {
  const DetoxDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detox Program'),
        backgroundColor: const Color(0xFF0077B6),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Detox Detail Content'),
      ),
    );
  }
}
```

**Step 3: Update Navigasi di ServiceGrid**

```powershell
code c:\xampp\htdocs\projects\clinic01\mobile_app\lib\widgets\service_grid.dart
```

Tambahkan import dan update `_navigateToService`:
```dart
import '../screens/detox/detox_detail_screen.dart';

void _navigateToService(ServiceModel service, BuildContext context) {
  switch (service.route) {
    case '/detox':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetoxDetailScreen()),
      );
      break;
    // ... other cases
  }
}
```

### 3.2 Template Command untuk Fitur Baru

```powershell
# Template untuk menambahkan fitur XYZ

# 1. Buat struktur folder
cd c:\xampp\htdocs\projects\clinic01\mobile_app\lib
mkdir screens\xyz
mkdir models\xyz
mkdir services\api

# 2. Buat file-file komponen
type nul > screens\xyz\xyz_screen.dart
type nul > models\xyz\xyz_model.dart
type nul > services\api\xyz_service.dart

# 3. Edit file menggunakan VS Code
code screens\xyz\xyz_screen.dart

# 4. Update pubspec.yaml jika perlu asset baru
# (manual edit via VS Code)

# 5. Test
cd c:\xampp\htdocs\projects\clinic01\mobile_app
flutter run -d chrome
```

---

## 4. Edit Account Profile dengan Logout

### 4.1 Struktur Profile Screen

```powershell
# Buat folder dan file profile
cd c:\xampp\htdocs\projects\clinic01\mobile_app\lib
mkdir screens\profile
type nul > screens\profile\profile_screen.dart
```

### 4.2 Template ProfileScreen dengan Logout

```dart
// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Jika ada auth service

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    // TODO: Implement logout logic
    // 1. Clear shared preferences / token
    // 2. Navigate to login screen
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement logout
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0077B6),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Profile info section
          _buildProfileHeader(),
          
          // Menu items
          _buildMenuItem(Icons.person, 'Edit Profile', () {}),
          _buildMenuItem(Icons.lock, 'Change Password', () {}),
          _buildMenuItem(Icons.notifications, 'Notifications', () {}),
          
          const Spacer(),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF0077B6),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nama User',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('user@email.com'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0077B6)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
```

### 4.3 Command Update Navigasi Account

```powershell
# Update home_screen.dart untuk navigasi ke Profile
code c:\xampp\htdocs\projects\clinic01\mobile_app\lib\screens\home\home_screen.dart

# Cari bagian Account TextButton dan update:
```

```dart
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  },
  child: const Text(
    'Account',
    style: TextStyle(color: Color(0xFF0077B6), fontSize: 12),
  ),
),
```

---

## 5. Integrasi REST API Laravel 11

### 5.1 Setup Laravel 11 Backend

```powershell
# 1. Navigasi ke workspace
cd c:\xampp\htdocs\projects\clinic01

# 2. Install Laravel 11 via Composer
composer create-project laravel/laravel backend_laravel "11.*"

# 3. Masuk ke folder Laravel
cd backend_laravel

# 4. Setup environment
copy .env.example .env

# 5. Generate application key
php artisan key:generate

# 6. Setup database di .env
# Edit .env file:
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=klinik_bsi
# DB_USERNAME=root
# DB_PASSWORD=

# 7. Buat database di MySQL
mysql -u root -e "CREATE DATABASE klinik_bsi;"

# 8. Jalankan migrasi
php artisan migrate

# 9. Install Sanctum untuk API authentication
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan migrate

# 10. Install CORS
composer require fruitcake/laravel-cors
```

### 5.2 Struktur API Routes

```php
// routes/api.php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\BannerController;
use App\Http\Controllers\Api\AppointmentController;

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // Services
    Route::get('/services', [ServiceController::class, 'index']);
    Route::get('/services/{id}', [ServiceController::class, 'show']);
    
    // Banners
    Route::get('/banners', [BannerController::class, 'index']);
    
    // Appointments
    Route::get('/appointments', [AppointmentController::class, 'index']);
    Route::post('/appointments', [AppointmentController::class, 'store']);
});
```

### 5.3 Service Controller Template

```powershell
# Buat controller
cd c:\xampp\htdocs\projects\clinic01\backend_laravel
php artisan make:controller Api/ServiceController --api
```

```php
// app/Http/Controllers/Api/ServiceController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    public function index()
    {
        $services = Service::all();
        return response()->json([
            'success' => true,
            'data' => $services
        ]);
    }

    public function show($id)
    {
        $service = Service::find($id);
        
        if (!$service) {
            return response()->json([
                'success' => false,
                'message' => 'Service not found'
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'data' => $service
        ]);
    }
}
```

### 5.4 Model & Migration

```powershell
# Buat model dan migration
php artisan make:model Service -m
php artisan make:model Banner -m
php artisan make:model Appointment -m
```

```php
// database/migrations/xxxx_create_services_table.php
Schema::create('services', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->string('icon');
    $table->string('route');
    $table->text('description');
    $table->string('price')->nullable();
    $table->timestamps();
});
```

```powershell
# Jalankan migrasi
php artisan migrate

# Buat seeder
php artisan make:seeder ServiceSeeder

# Jalankan seeder
php artisan db:seed --class=ServiceSeeder
```

### 5.5 Flutter API Service Integration

```powershell
# Buat folder dan file API service di Flutter
cd c:\xampp\htdocs\projects\clinic01\mobile_app\lib
mkdir services\api
type nul > services\api\api_service.dart
```

```dart
// lib/services/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL - akan dijelaskan di bagian Dynamic API Paths
  static String baseUrl = 'http://localhost:8000/api';
  
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET request
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await getHeaders(),
    );
    
    return jsonDecode(response.body);
  }

  // POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await getHeaders(),
      body: jsonEncode(body),
    );
    
    return jsonDecode(response.body);
  }

  // Login
  static Future<bool> login(String email, String password) async {
    final response = await post('login', {
      'email': email,
      'password': password,
    });
    
    if (response['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('user', jsonEncode(response['user']));
      return true;
    }
    return false;
  }

  // Logout
  static Future<void> logout() async {
    await post('logout', {});
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
}
```

### 5.6 Dependencies Flutter

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  shared_preferences: ^2.2.2
```

```powershell
# Install dependencies
cd c:\xampp\htdocs\projects\clinic01\mobile_app
flutter pub get
```

---

## 6. Admin Dashboard Laravel 11 + Bootstrap

### 6.1 Setup Admin Dashboard

```powershell
# Navigasi ke Laravel project
cd c:\xampp\htdocs\projects\clinic01\backend_laravel

# Install Bootstrap via NPM (jika belum)
npm install
npm install bootstrap @popperjs/core

# Install Laravel UI (optional, untuk auth scaffolding)
composer require laravel/ui
php artisan ui bootstrap --auth

# Compile assets
npm run dev          # Development
npm run build        # Production
```

### 6.2 Admin Controller & Routes

```powershell
# Buat Admin Controller
php artisan make:controller Admin/DashboardController
php artisan make:controller Admin/ServiceController
```

```php
// routes/web.php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\ServiceController;

// Admin routes
Route::prefix('admin')->middleware(['auth', 'admin'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('admin.dashboard');
    
    // Services CRUD
    Route::get('/services', [ServiceController::class, 'index'])->name('admin.services.index');
    Route::get('/services/create', [ServiceController::class, 'create'])->name('admin.services.create');
    Route::post('/services', [ServiceController::class, 'store'])->name('admin.services.store');
    Route::get('/services/{id}/edit', [ServiceController::class, 'edit'])->name('admin.services.edit');
    Route::put('/services/{id}', [ServiceController::class, 'update'])->name('admin.services.update');
    Route::delete('/services/{id}', [ServiceController::class, 'destroy'])->name('admin.services.destroy');
});
```

### 6.3 Admin Dashboard Template (Blade)

```powershell
# Buat folder views admin
mkdir resources\views\admin
mkdir resources\views\admin\layouts
mkdir resources\views\admin\services
```

```html
<!-- resources/views/admin/layouts/app.blade.php -->
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BSI Clinic Admin - @yield('title')</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh;">
            <h4 class="mb-4">BSI Clinic</h4>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link text-white" href="{{ route('admin.dashboard') }}">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="{{ route('admin.services.index') }}">Services</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="#">Appointments</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="#">Users</a>
                </li>
                <li class="nav-item mt-3">
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit" class="btn btn-danger btn-sm w-100">Logout</button>
                    </form>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="flex-grow-1 p-4">
            @yield('content')
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

```html
<!-- resources/views/admin/services/index.blade.php -->
@extends('admin.layouts.app')

@section('title', 'Services')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Kelola Services</h2>
    <a href="{{ route('admin.services.create') }}" class="btn btn-primary">Tambah Service</a>
</div>

<table class="table table-striped">
    <thead>
        <tr>
            <th>ID</th>
            <th>Nama</th>
            <th>Icon</th>
            <th>Route</th>
            <th>Deskripsi</th>
            <th>Aksi</th>
        </tr>
    </thead>
    <tbody>
        @foreach($services as $service)
        <tr>
            <td>{{ $service->id }}</td>
            <td>{{ $service->name }}</td>
            <td>{{ $service->icon }}</td>
            <td>{{ $service->route }}</td>
            <td>{{ $service->description }}</td>
            <td>
                <a href="{{ route('admin.services.edit', $service->id) }}" class="btn btn-sm btn-warning">Edit</a>
                <form action="{{ route('admin.services.destroy', $service->id) }}" method="POST" class="d-inline">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Yakin ingin menghapus?')">Hapus</button>
                </form>
            </td>
        </tr>
        @endforeach
    </tbody>
</table>
@endsection
```

### 6.4 Admin Middleware

```powershell
php artisan make:middleware AdminMiddleware
```

```php
// app/Http/Middleware/AdminMiddleware.php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        if (!auth()->check() || auth()->user()->role !== 'admin') {
            return redirect('/login');
        }
        return $next($request);
    }
}
```

```php
// bootstrap/app.php - Register middleware
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'admin' => \App\Http\Middleware\AdminMiddleware::class,
    ]);
})
```

### 6.5 Menjalankan Admin Dashboard

```powershell
# Terminal 1: Jalankan Laravel Server
cd c:\xampp\htdocs\projects\clinic01\backend_laravel
php artisan serve

# Terminal 2: Compile Assets (jika menggunakan Vite)
cd c:\xampp\htdocs\projects\clinic01\backend_laravel
npm run dev

# Akses admin dashboard
# http://localhost:8000/admin/dashboard
```

---

## 7. Dynamic API Paths Multiplatform

### 7.1 Environment Configuration

**Flutter (.env atau constants):**

```dart
// lib/config/app_config.dart
class AppConfig {
  // Environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  
  // Base URLs berdasarkan environment
  static String get baseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.klinikbsi.com/api';
      case 'staging':
        return 'https://staging.klinikbsi.com/api';
      case 'development':
      default:
        // Untuk Android Emulator
        if (isAndroidEmulator) {
          return 'http://10.0.2.2:8000/api';
        }
        // Untuk Web/Chrome
        return 'http://localhost:8000/api';
    }
  }
  
  static bool get isAndroidEmulator {
    // Check platform
    return false; // Implementasi platform check
  }
}
```

**Laravel CORS Configuration:**

```php
// config/cors.php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://localhost:*',
        'https://klinikbsi.com',
        'capacitor://localhost',    // Mobile
        'ionic://localhost',          // Mobile
    ],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

### 7.2 API Service dengan Dynamic Base URL

```dart
// lib/services/api/api_service.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String getBaseUrl() {
    // Web Platform
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    
    // Android
    if (Platform.isAndroid) {
      // Emulator
      return 'http://10.0.2.2:8000/api';
      // Real Device (ganti dengan IP komputer)
      // return 'http://192.168.1.100:8000/api';
    }
    
    // iOS
    if (Platform.isIOS) {
      // Simulator
      return 'http://localhost:8000/api';
      // Real Device
      // return 'http://192.168.1.100:8000/api';
    }
    
    // Default
    return 'http://localhost:8000/api';
  }
  
  static String getImageUrl(String path) {
    final baseUrl = getBaseUrl().replaceAll('/api', '');
    return '$baseUrl/storage/$path';
  }
}
```

### 7.3 Network & Local Testing Matrix

| Platform | Local Development | Network (Same WiFi) | Production |
|----------|-------------------|---------------------|------------|
| **Web/Chrome** | `localhost:8000` | `192.168.x.x:8000` | `api.domain.com` |
| **Android Emulator** | `10.0.2.2:8000` | `192.168.x.x:8000` | `api.domain.com` |
| **Android Device** | `192.168.x.x:8000` | `192.168.x.x:8000` | `api.domain.com` |
| **iOS Simulator** | `localhost:8000` | `192.168.x.x:8000` | `api.domain.com` |
| **iOS Device** | `192.168.x.x:8000` | `192.168.x.x:8000` | `api.domain.com` |

### 7.4 Command untuk Testing Multiplatform

```powershell
# 1. Jalankan Laravel dengan host 0.0.0.0 (agar bisa diakses dari network)
cd c:\xampp\htdocs\projects\clinic01\backend_laravel
php artisan serve --host=0.0.0.0 --port=8000

# 2. Cek IP address komputer (untuk testing di device)
ipconfig              # Windows
ifconfig              # Linux/Mac

# 3. Update baseUrl di Flutter sesuai IP
# Contoh: http://192.168.1.100:8000/api

# 4. Jalankan Flutter di berbagai platform
# Web
flutter run -d chrome --web-port=5000

# Android Emulator
flutter run

# Android Device (pastikan USB debugging aktif)
flutter devices         # Cek device ID
flutter run -d <device_id>

# iOS (Mac only)
flutter run

# 5. Build untuk deployment
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

### 7.5 AndroidManifest.xml Configuration

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="BSI Clinic"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">  <!-- Penting untuk HTTP -->
        ...
    </application>
</manifest>
```

---

## 8. Command Cheat Sheet

### 8.1 Flutter Commands

```powershell
# Development
cd c:\xampp\htdocs\projects\clinic01\mobile_app

flutter doctor                    # Check environment
flutter pub get                   # Install dependencies
flutter pub upgrade               # Upgrade dependencies

flutter run -d chrome             # Run in Chrome
flutter run -d edge               # Run in Edge
flutter run                       # Run default device

flutter clean                     # Clean build cache
flutter build apk --debug         # Build debug APK
flutter build apk --release       # Build release APK
flutter build web                 # Build web

flutter analyze                   # Static analysis
flutter test                      # Run tests
```

### 8.2 Laravel Commands

```powershell
# Development
cd c:\xampp\htdocs\projects\clinic01\backend_laravel

php artisan serve                 # Start development server
php artisan serve --host=0.0.0.0 --port=8000

php artisan migrate               # Run migrations
php artisan migrate:fresh         # Fresh migrations
php artisan migrate:rollback      # Rollback migrations

php artisan db:seed               # Run seeders
php artisan migrate:fresh --seed  # Fresh + seed

php artisan make:model User -m    # Model + migration
php artisan make:controller Api/UserController --api
php artisan make:middleware AuthMiddleware
php artisan make:request StoreUserRequest

php artisan route:list            # List all routes
php artisan optimize              # Optimize application
php artisan cache:clear           # Clear cache
php artisan config:clear          # Clear config cache
php artisan view:clear            # Clear view cache

composer install                  # Install dependencies
composer update                   # Update dependencies
dump-autoload -o                  # Optimize autoload
```

### 8.3 Git Commands

```powershell
# Setup
git init
git remote add origin https://github.com/username/repo.git

# Workflow
git add .
git commit -m "feat: add new feature"
git push origin main

# Branching
git checkout -b feature/new-feature
git checkout main
git merge feature/new-feature

# Check status
git status
git log --oneline
git branch
```

### 8.4 MySQL/MariaDB Commands

```powershell
# Login
mysql -u root -p

# Commands
CREATE DATABASE klinik_bsi;
USE klinik_bsi;
SHOW TABLES;
DESCRIBE users;

# Import/Export
mysqldump -u root -p klinik_bsi > backup.sql
mysql -u root -p klinik_bsi < backup.sql
```

---

## 9. Troubleshooting

### 9.1 Flutter Issues

| Issue | Solution |
|-------|----------|
| `Connection refused` | Check if Laravel server running, update baseUrl |
| `CORS error` | Update Laravel CORS config, add allowed origins |
| `SocketException` | Check internet permission in AndroidManifest |
| `404 Not Found` | Check API routes, update baseUrl |
| `401 Unauthorized` | Check token, login again |

### 9.2 Laravel Issues

| Issue | Solution |
|-------|----------|
| `500 Server Error` | Check Laravel logs: `storage/logs/laravel.log` |
| `Database connection failed` | Check .env DB config, ensure MySQL running |
| `Class not found` | Run `composer dump-autoload` |
| `Route not found` | Clear route cache: `php artisan route:clear` |
| `CORS blocked` | Update config/cors.php allowed_origins |

---

## 10. Production Deployment Checklist

### 10.1 Flutter Production

- [ ] Update baseUrl ke production API
- [ ] Enable ProGuard untuk Android (minifyEnabled true)
- [ ] Generate signed APK/AppBundle
- [ ] Test di berbagai device sizes
- [ ] Upload ke Play Store/App Store

### 10.2 Laravel Production

- [ ] Update .env: `APP_ENV=production`, `APP_DEBUG=false`
- [ ] Generate application key
- [ ] Konfigurasi database production
- [ ] Setup queue worker (jika pakai queue)
- [ ] Konfigurasi SSL/HTTPS
- [ ] Setup proper file permissions
- [ ] Konfigurasi backup otomatis

```powershell
# Production setup commands
php artisan key:generate
php artisan migrate --force
php artisan optimize
php artisan route:cache
php artisan view:cache
php artisan config:cache
```

---

## Dokumentasi ini disusun untuk:
- **Project**: Klinik BSI Flutter + Laravel
- **Flutter Version**: 3.x+
- **Laravel Version**: 11.x
- **PHP Version**: 8.2+
- **Last Updated**: April 2026

Untuk pertanyaan atau update dokumentasi, silakan hubungi tim development.
