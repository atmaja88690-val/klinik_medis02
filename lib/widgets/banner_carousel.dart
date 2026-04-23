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

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final carouselHeight = isSmallScreen ? 160.0 : 200.0;

        return Column(
          children: [
            // Carousel slider untuk banner
            CarouselSlider.builder(
              itemCount: widget.banners.length,
              itemBuilder: (context, index, realIndex) {
                final banner = widget.banners[index];
                return _buildBannerCard(banner, isSmallScreen);
              },
              options: CarouselOptions(
                height: carouselHeight,
                viewportFraction: isSmallScreen ? 0.95 : 0.85,
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
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? const Color(0xFF0077B6)
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  /// Widget untuk menampilkan satu banner card
  ///
  /// Membuat tampilan card banner dengan background color sesuai data,
  /// gambar dari URL, judul promosi, deskripsi, harga original dan diskon,
  /// serta tombol CTA.
  Widget _buildBannerCard(BannerModel banner, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(int.parse(banner.color.replaceFirst('#', '0xFF'))),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Left side: Solid blue color with content (30%)
            Expanded(
              flex: 50,
              child: Container(
                color: Color(int.parse(banner.color.replaceFirst('#', '0xFF'))),
                padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        banner.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        banner.subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 9 : 11,
                        ),
                        maxLines: isSmallScreen ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            banner.originalPrice,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 9 : 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            banner.discountPrice,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: isSmallScreen ? 24 : 28,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement navigation ke detail promosi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0077B6),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: 0,
                          ),
                          minimumSize: Size(0, isSmallScreen ? 24 : 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          banner.cta,
                          style: TextStyle(fontSize: isSmallScreen ? 9 : 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right side: Image with gradient overlay at left edge (70%)
            Expanded(
              flex: 50,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      banner.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color(int.parse(banner.color.replaceFirst('#', '0xFF'))),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                          colors: [
                            Color(0xFF0077B6),
                            Color(0xFF0077B6).withValues(alpha: 0.8),
                            Color(0xFF0077B6).withValues(alpha: 0.6),
                            Color(0xFF0077B6).withValues(alpha: 0.4),
                            Color(0xFF0077B6).withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
