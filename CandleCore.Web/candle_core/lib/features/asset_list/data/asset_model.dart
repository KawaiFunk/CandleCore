class AssetModel {
  final int id;
  final String symbol;
  final String name;
  final double priceUsd;
  final double percentChange1h;

  const AssetModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.percentChange1h,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: (json['id'] ?? 0) as int,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      priceUsd: (json['priceUsd'] ?? 0).toDouble(),
      percentChange1h: (json['percentChange1h'] ?? 0).toDouble(),
    );
  }
}
