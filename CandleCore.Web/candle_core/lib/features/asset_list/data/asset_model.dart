class AssetModel {
  final String symbol;
  final String name;
  final double priceUsd;
  final double percentChange1h;

  const AssetModel({
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.percentChange1h,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      priceUsd: (json['priceUsd'] ?? 0).toDouble(),
      percentChange1h: (json['percentChange1h'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'priceUsd': priceUsd,
    'percentChange1h': percentChange1h,
  };
}
