# Dashboard Documentation

## Overview
Dashboard BSI Clinic App menampilkan halaman utama dengan carousel banner, grid layanan, dan section updates. Dokumentasi ini menjelaskan widget-widget yang digunakan, lokasi source code, dan penjelasan blok source code.

---

## Widget Components

### 1. BannerCarousel Widget

**Lokasi:** `lib/widgets/banner_carousel.dart`

**Deskripsi:** Widget carousel banner yang menampilkan promosi secara bergantian dengan auto-play. Banner dapat digeser secara horizontal dan memiliki indikator dots untuk navigasi.

**Source Code:**
```dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/banner_model.dart';

/// Widget BannerCarousel
/// 
/// Widget ini menampilkan carousel banner promosi di bagian atas halaman home.
/// Banner dapat digeser secara horizontal dan menampilkan informasi promosi
/// seperti judul, deskripsi, harga, dan tombol call-to-action.
/// 
/// Lokasi: lib/widgets/banner_carousel.dart
class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerCarousel({
    super.key,
    required this.banners,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Carousel slider untuk banner
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = widget.banners[index];
            return _buildBannerCard(banner);
          },
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        // Indikator dots untuk navigasi carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? const Color(0xFF0077B6)
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Widget untuk menampilkan satu banner card
  /// 
  /// Membuat tampilan card banner dengan background color sesuai data,
  /// judul promosi, deskripsi, harga original dan diskon, serta tombol CTA.
  Widget _buildBannerCard(BannerModel banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(int.parse(banner.color.replaceFirst('#', '0xFF'))),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              banner.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              banner.subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  banner.originalPrice,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  banner.discountPrice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement navigation ke detail promosi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0077B6),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(banner.cta),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Blok Code:**
- **StatefulWidget:** Menggunakan StatefulWidget karena perlu mengelola state `_currentIndex` untuk indikator carousel
- **CarouselController:** Controller untuk mengontrol carousel secara programmatic
- **CarouselOptions:** Konfigurasi carousel seperti height, auto-play, dan animation duration
- **Indikator Dots:** Row dengan dots yang menunjukkan banner aktif, dapat diklik untuk navigasi
- **_buildBannerCard:** Method private untuk membangun tampilan satu banner dengan background color dari data JSON

---

### 2. ServiceGrid Widget

**Lokasi:** `lib/widgets/service_grid.dart`

**Deskripsi:** Widget grid yang menampilkan layanan klinik dalam bentuk circular icons. Setiap layanan ditampilkan dengan icon, nama, dan harga (jika ada).

**Source Code:**
```dart
import 'package:flutter/material.dart';
import '../models/service_model.dart';

/// Widget ServiceGrid
/// 
/// Widget ini menampilkan grid layanan klinik dalam bentuk circular icons.
/// Setiap layanan ditampilkan dengan icon, nama, dan harga (jika ada).
/// 
/// Lokasi: lib/widgets/service_grid.dart
class ServiceGrid extends StatelessWidget {
  final List<ServiceModel> services;

  const ServiceGrid({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceItem(service);
      },
    );
  }

  /// Widget untuk menampilkan satu item layanan
  /// 
  /// Membuat tampilan circular icon dengan nama layanan di bawahnya.
  /// Jika layanan memiliki harga, harga akan ditampilkan di bawah nama.
  Widget _buildServiceItem(ServiceModel service) {
    return Column(
      children: [
        // Circular container untuk icon layanan
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF0077B6).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconData(service.icon),
            color: const Color(0xFF0077B6),
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        // Nama layanan
        Text(
          service.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // Harga layanan (jika ada)
        if (service.price.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            service.price,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF0077B6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  /// Helper method untuk mendapatkan IconData berdasarkan string icon name
  /// 
  /// Mapping string icon name ke IconData Material Icons.
  /// Jika icon tidak ditemukan, menggunakan Icons.star sebagai default.
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
      default:
        return Icons.star;
    }
  }
}
```

**Penjelasan Blok Code:**
- **GridView.builder:** Menggunakan GridView untuk menampilkan layanan dalam grid dengan 4 kolom
- **SliverGridDelegateWithFixedCrossAxisCount:** Konfigurasi grid dengan 4 kolom, spacing, dan aspect ratio
- **_buildServiceItem:** Method private untuk membangun satu item layanan dengan circular icon
- **_getIconData:** Helper method untuk mapping string icon name ke IconData Material Icons
- **Conditional Rendering:** Harga hanya ditampilkan jika field price tidak kosong

---

### 3. UpdateCard Widget

**Lokasi:** `lib/widgets/update_card.dart`

**Deskripsi:** Widget card yang menampilkan update/promosi di section "UPDATES". Card ditampilkan secara horizontal dengan shadow effect.

**Source Code:**
```dart
import 'package:flutter/material.dart';
import '../models/banner_model.dart';

/// Widget UpdateCard
/// 
/// Widget ini menampilkan card update/promosi di section "UPDATES".
/// Card ditampilkan secara horizontal dan menampilkan informasi singkat
/// tentang promosi atau update terbaru.
/// 
/// Lokasi: lib/widgets/update_card.dart
class UpdateCard extends StatelessWidget {
  final BannerModel banner;

  const UpdateCard({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul update
            Text(
              banner.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Deskripsi update
            Text(
              banner.subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Harga
            Row(
              children: [
                Text(
                  banner.originalPrice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  banner.discountPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077B6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Blok Code:**
- **StatelessWidget:** Widget ini tidak memerlukan state management karena hanya menampilkan data yang diterima
- **Container dengan BoxDecoration:** Memberikan background putih, border radius, dan shadow effect
- **BoxShadow:** Memberikan efek shadow halus pada card untuk depth
- **Column Layout:** Menyusun elemen secara vertikal: judul, deskripsi, dan harga
- **Harga dengan Strikethrough:** Menampilkan harga original dengan dekorasi line-through dan harga diskon yang lebih menonjol

---

### 4. HomeScreen Widget

**Lokasi:** `lib/screens/home/home_screen.dart`

**Deskripsi:** Halaman utama dashboard yang mengintegrasikan BannerCarousel, ServiceGrid, dan UpdateCard. Memuat data dari file JSON dan mengelola state loading/error.

**Source Code:**
```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/banner_model.dart';
import '../../models/service_model.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/service_grid.dart';
import '../../widgets/update_card.dart';

/// HomeScreen - Halaman utama dashboard aplikasi
/// 
/// Menampilkan carousel banner, grid layanan, dan section updates.
/// Data dimuat dari file JSON di assets/data/.
/// 
/// Lokasi: lib/screens/home/home_screen.dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables untuk menyimpan data dan status loading
  List<BannerModel> _banners = [];
  List<ServiceModel> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Method untuk memuat data banner dan service dari file JSON
  /// 
  /// Membaca file banners.json dan services.json dari assets,
  /// lalu mengkonversinya ke model objects.
  Future<void> _loadData() async {
    try {
      // Load banners dari JSON
      final bannersJson = await rootBundle.loadString('assets/data/banners.json');
      final bannersList = json.decode(bannersJson) as List;
      _banners = bannersList.map((json) => BannerModel.fromJson(json)).toList();

      // Load services dari JSON
      final servicesJson = await rootBundle.loadString('assets/data/services.json');
      final servicesList = json.decode(servicesJson) as List;
      _services = servicesList.map((json) => ServiceModel.fromJson(json)).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF0077B6)),
          onPressed: () {
            // TODO: Implement notifications
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo BSI Clinic
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF0077B6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_hospital, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'BSI Clinic',
              style: TextStyle(
                color: Color(0xFF0077B6),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Navigate to account screen
            },
            child: const Text(
              'Account',
              style: TextStyle(color: Color(0xFF0077B6), fontSize: 12),
            ),
          ),
        ],
      ),
      // Tampilkan loading indicator jika sedang memuat data
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0077B6)))
          // Tampilkan error message jika terjadi error
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
              // Tampilkan konten utama dashboard
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Widget BannerCarousel untuk menampilkan carousel banner
                      BannerCarousel(banners: _banners),
                      const SizedBox(height: 24),
                      // Widget ServiceGrid untuk menampilkan grid layanan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ServiceGrid(services: _services),
                      ),
                      const SizedBox(height: 24),
                      // Header section UPDATES
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'UPDATES',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Horizontal list update cards menggunakan UpdateCard widget
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _banners.length,
                          itemBuilder: (context, index) => UpdateCard(banner: _banners[index]),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}
```

**Penjelasan Blok Code:**
- **StatefulWidget:** Menggunakan StatefulWidget untuk mengelola state loading, error, dan data
- **State Variables:** `_banners`, `_services`, `_isLoading`, `_error` untuk menyimpan data dan status
- **initState:** Memanggil `_loadData()` saat widget pertama kali diinisialisasi
- **_loadData:** Method async untuk memuat data dari file JSON menggunakan `rootBundle.loadString`
- **Conditional Rendering:** Menampilkan loading indicator, error message, atau konten utama berdasarkan state
- **SingleChildScrollView:** Memungkinkan konten di-scroll jika melebihi tinggi layar
- **AppBar:** Custom app bar dengan logo BSI Clinic, notification icon, dan account button

---

## Data Models

### 1. BannerModel

**Lokasi:** `lib/models/banner_model.dart`

**Deskripsi:** Model untuk data banner/promosi. Merepresentasikan setiap banner yang ditampilkan di carousel.

**Source Code:**
```dart
/// Model untuk data banner/promosi di dashboard
/// 
/// Kelas ini merepresentasikan data banner yang ditampilkan di carousel
/// pada halaman home screen.
class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String cta; // Call to Action text
  final String originalPrice;
  final String discountPrice;
  final String note;
  final String color;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.originalPrice,
    required this.discountPrice,
    required this.note,
    required this.color,
  });

  /// Factory constructor untuk membuat BannerModel dari JSON
  /// 
  /// Digunakan saat memuat data banner dari file JSON atau API
  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    cta: json['cta'] as String,
    originalPrice: json['original_price'] as String,
    discountPrice: json['discount_price'] as String,
    note: json['note'] as String,
    color: json['color'] as String,
  );
}
```

---

### 2. ServiceModel

**Lokasi:** `lib/models/service_model.dart`

**Deskripsi:** Model untuk data layanan klinik. Merepresentasikan setiap layanan yang ditampilkan di grid.

**Source Code:**
```dart
/// Model untuk data layanan klinik
/// 
/// Kelas ini merepresentasikan setiap layanan yang tersedia di klinik
/// dan ditampilkan di grid layanan pada halaman home.
class ServiceModel {
  final int id;
  final String name;
  final String icon;
  final String route;
  final String description;
  final String price;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.route,
    required this.description,
    required this.price,
  });

  /// Factory constructor untuk membuat ServiceModel dari JSON
  /// 
  /// Digunakan saat memuat data layanan dari file JSON atau API
  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] as int,
    name: json['name'] as String,
    icon: json['icon'] as String,
    route: json['route'] as String,
    description: json['description'] as String,
    price: json['price'] as String,
  );
}
```

---

## Data Files

### 1. banners.json

**Lokasi:** `assets/data/banners.json`

**Deskripsi:** File JSON yang berisi data banner/promosi untuk carousel.

**Format:**
```json
[
  {
    "id": 1,
    "title": "Deep Dive",
    "subtitle": "Parasites & Disease Testing and Remedies Service",
    "cta": "Get Tested Today!",
    "original_price": "Rp. 7.000K",
    "discount_price": "Rp. 5.500K",
    "note": "by popular demand, this offer is extended",
    "color": "#0077b6"
  },
  {
    "id": 2,
    "title": "IV Therapy Special",
    "subtitle": "Boost Your Immunity with Our Premium IV Drip",
    "cta": "Book Now!",
    "original_price": "Rp. 3.500K",
    "discount_price": "Rp. 2.800K",
    "note": "Limited slots available every week",
    "color": "#005F8E"
  },
  {
    "id": 3,
    "title": "BSI Signature Package",
    "subtitle": "Evidence-Based Comprehensive Health Assessment",
    "cta": "Learn More",
    "original_price": "Rp. 5.000K",
    "discount_price": "Rp. 4.000K",
    "note": "Includes full blood panel and consultation",
    "color": "#003F6B"
  }
]
```

---

### 2. services.json

**Lokasi:** `assets/data/services.json`

**Deskripsi:** File JSON yang berisi data layanan klinik untuk grid.

**Format:**
```json
[
  {
    "id": 1,
    "name": "BSI Signature\nEvidence-Based",
    "icon": "microscope",
    "route": "/service/1",
    "description": "Paket layanan unggulan BSI berbasis bukti ilmiah.",
    "price": "Rp. 4.000K"
  },
  {
    "id": 2,
    "name": "Blood &\nUrine Tests",
    "icon": "test_tube",
    "route": "/service/2",
    "description": "Pemeriksaan darah dan urin lengkap.",
    "price": "Rp. 1.500K"
  },
  {
    "id": 3,
    "name": "IV Therapy",
    "icon": "iv_bag",
    "route": "/service/3",
    "description": "Terapi infus intravena untuk meningkatkan imunitas.",
    "price": "Rp. 2.800K"
  },
  {
    "id": 4,
    "name": "Book\nAppointment",
    "icon": "calendar",
    "route": "/book-appointment",
    "description": "Pesan janji temu dengan dokter.",
    "price": ""
  },
  {
    "id": 5,
    "name": "Chat Us",
    "icon": "chat",
    "route": "/chat",
    "description": "Hubungi staf klinik BSI.",
    "price": ""
  },
  {
    "id": 7,
    "name": "Educational\nTips",
    "icon": "book",
    "route": "/service/7",
    "description": "Edukasi kesehatan dari para ahli BSI.",
    "price": "Gratis"
  }
]
```

---

## Dependencies

Untuk menjalankan dashboard ini, pastikan dependencies berikut sudah ditambahkan di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  carousel_slider: ^5.0.0  # Untuk BannerCarousel
```

---

## Summary

### Widget yang Digunakan:
1. **BannerCarousel** - Carousel banner promosi dengan auto-play
2. **ServiceGrid** - Grid layanan dengan circular icons
3. **UpdateCard** - Card update/promosi di section UPDATES
4. **HomeScreen** - Halaman utama yang mengintegrasikan semua widget

### Lokasi Source Code:
- **Widgets:** `lib/widgets/`
  - `banner_carousel.dart`
  - `service_grid.dart`
  - `update_card.dart`
- **Screens:** `lib/screens/home/`
  - `home_screen.dart`
- **Models:** `lib/models/`
  - `banner_model.dart`
  - `service_model.dart`
- **Data:** `assets/data/`
  - `banners.json`
  - `services.json`

### Komentar dalam Source Code:
Setiap file memiliki dokumentasi komentar yang menjelaskan:
- Deskripsi widget/kelas
- Lokasi file
- Penjelasan method penting
- Penjelasan blok code yang kompleks
