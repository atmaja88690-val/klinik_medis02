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
