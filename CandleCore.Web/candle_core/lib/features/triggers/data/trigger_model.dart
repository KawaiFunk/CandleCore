enum AlarmCondition { above, below }

class TriggerModel {
  final int id;
  final int userId;
  final int assetId;
  final String assetName;
  final AlarmCondition condition;
  final double targetPrice;
  final bool isActive;
  final DateTime? triggeredAt;
  final DateTime createdAtUtc;

  const TriggerModel({
    required this.id,
    required this.userId,
    required this.assetId,
    required this.assetName,
    required this.condition,
    required this.targetPrice,
    required this.isActive,
    this.triggeredAt,
    required this.createdAtUtc,
  });

  factory TriggerModel.fromJson(Map<String, dynamic> json) => TriggerModel(
        id: json['id'] as int,
        userId: json['userId'] as int,
        assetId: json['assetId'] as int,
        assetName: json['assetName'] as String,
        condition: (json['condition'] as int) == 0
            ? AlarmCondition.above
            : AlarmCondition.below,
        targetPrice: (json['targetPrice'] as num).toDouble(),
        isActive: json['isActive'] as bool,
        triggeredAt: json['triggeredAt'] != null
            ? DateTime.parse(json['triggeredAt'] as String)
            : null,
        createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      );

  TriggerModel copyWith({bool? isActive}) => TriggerModel(
        id: id,
        userId: userId,
        assetId: assetId,
        assetName: assetName,
        condition: condition,
        targetPrice: targetPrice,
        isActive: isActive ?? this.isActive,
        triggeredAt: triggeredAt,
        createdAtUtc: createdAtUtc,
      );
}
