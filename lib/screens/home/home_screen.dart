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
            Center(
              child: Image.asset(
                'assets/images/bsi_header.jpg',
                height: 46,
                fit: BoxFit.contain,
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
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _banners.length,
                          itemBuilder: (context, index) => UpdateCard(banner: _banners[index]),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }
}
