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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 400;

        return Container(
          width: isSmallScreen ? 240 : 280,
          margin: EdgeInsets.only(right: isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Judul update
                Flexible(
                  child: Text(
                    banner.title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 3 : 4),
                // Deskripsi update
                Flexible(
                  child: Text(
                    banner.subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 11,
                      color: Colors.grey,
                    ),
                    maxLines: isSmallScreen ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 5 : 6),
                // Harga
                Row(
                  children: [
                    Text(
                      banner.originalPrice,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 3 : 4),
                    Text(
                      banner.discountPrice,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0077B6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
