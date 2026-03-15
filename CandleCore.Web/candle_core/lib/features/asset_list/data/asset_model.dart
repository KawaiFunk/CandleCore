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

class DetailedAssetModel {
  final int id;
  final String symbol;
  final String name;
  final int rank;
  final double priceUsd;
  final double priceBtc;
  final double marketCapUsd;
  final double volume24a;
  final double percentChange1h;
  final double percentChange24h;
  final double percentChange7d;

  const DetailedAssetModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.rank,
    required this.priceUsd,
    required this.priceBtc,
    required this.marketCapUsd,
    required this.volume24a,
    required this.percentChange1h,
    required this.percentChange24h,
    required this.percentChange7d,
  });

  factory DetailedAssetModel.fromJson(Map<String, dynamic> json) {
    return DetailedAssetModel(
      id: (json['id'] ?? 0) as int,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      rank: (json['rank'] ?? 0) as int,
      priceUsd: (json['priceUsd'] ?? 0).toDouble(),
      priceBtc: (json['priceBtc'] ?? 0).toDouble(),
      marketCapUsd: (json['marketCapUsd'] ?? 0).toDouble(),
      volume24a: (json['volume24a'] ?? 0).toDouble(),
      percentChange1h: (json['percentChange1h'] ?? 0).toDouble(),
      percentChange24h: (json['percentChange24h'] ?? 0).toDouble(),
      percentChange7d: (json['percentChange7d'] ?? 0).toDouble(),
    );
  }
}
