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
  final String image; // URL gambar banner

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.originalPrice,
    required this.discountPrice,
    required this.note,
    required this.color,
    required this.image,
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
    image: json['image'] as String,
  );
}
