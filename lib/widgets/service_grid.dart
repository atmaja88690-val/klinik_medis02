import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../screens/chat/chat_screen.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on screen width
        final screenWidth = constraints.maxWidth;
        int crossAxisCount;
        double childAspectRatio;
        double iconSize;
        double fontSize;

        if (screenWidth < 400) {
          crossAxisCount = 3;
          childAspectRatio = 0.9;
          iconSize = 60;
          fontSize = 10;
        } else if (screenWidth < 600) {
          crossAxisCount = 4;
          childAspectRatio = 0.85;
          iconSize = 65;
          fontSize = 11;
        } else {
          crossAxisCount = 5;
          childAspectRatio = 0.9;
          iconSize = 70;
          fontSize = 12;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: services.length > 8 ? 8 : services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceItem(service, iconSize, fontSize, context);
          },
        );
      },
    );
  }

  /// Widget untuk menampilkan satu item layanan
  ///
  /// Membuat tampilan circular icon dengan nama layanan di bawahnya.
  /// Jika layanan memiliki harga, harga akan ditampilkan di bawah nama.
  Widget _buildServiceItem(ServiceModel service, double iconSize, double fontSize, BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateToService(service, context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          // Square container untuk icon layanan
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(service.icon),
              color: Colors.white,
              size: iconSize * 0.45,
            ),
          ),
          const SizedBox(height: 8),
          // Nama layanan
          Text(
            service.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
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
              style: TextStyle(
                fontSize: fontSize - 1,
                color: const Color(0xFF0077B6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Method untuk navigasi ke layanan yang sesuai
  void _navigateToService(ServiceModel service, BuildContext context) {
    switch (service.route) {
      case '/chat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
        break;
      default:
        // TODO: Implement navigation for other routes
        print('Navigate to: ${service.route}');
    }
  }

  /// Helper method untuk mendapatkan IconData berdasarkan string icon name
  /// 
  /// Mapping string icon name ke IconData Material Icons.
  /// Jika icon tidak ditemukan, menggunakan Icons.star sebagai default.
  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'biotech':
        return Icons.biotech;
      case 'vaccines':
        return Icons.vaccines;
      case 'water_drop':
        return Icons.water_drop;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'book':
        return Icons.menu_book;
      case 'medication':
        return Icons.medication;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.star;
    }
  }
}
