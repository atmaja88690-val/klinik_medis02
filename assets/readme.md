# Klinik Medis API (Laravel 11)

Backend REST API + Admin Dashboard untuk aplikasi Flutter `klinik_medis02`.

## Stack
- Laravel 11 (PHP 8.2+)
- Sanctum (auth token mobile + session admin web)
- MySQL 8 / MariaDB 10.6+
- Blade + Bootstrap 5 (CDN) untuk Admin Dashboard — **tanpa framework JavaScript**

## Quick Start

```bash
composer install
cp .env.example .env
php artisan key:generate

# Setup DB di .env, lalu:
php artisan migrate --seed
php artisan storage:link

# Listen ke 0.0.0.0 supaya bisa diakses dari Android emulator (10.0.2.2) & device LAN
php artisan serve --host=0.0.0.0 --port=8000
```

Admin login default (dari seeder):
- URL:      `http://127.0.0.1:8000/admin/login`
- Email:    `admin@klinik.test`
- Password: `password`

## Struktur Endpoint

Lihat dokumentasi lengkap di `../docs/PEDOMAN.md` Bagian 4.

## Tanpa Framework JavaScript

Admin Dashboard 100% Blade + Bootstrap 5 dari CDN. Chart memakai Chart.js (vanilla, via CDN), bukan React/Vue. Tidak ada `package.json`, tidak ada Vite asset bundling untuk admin.
