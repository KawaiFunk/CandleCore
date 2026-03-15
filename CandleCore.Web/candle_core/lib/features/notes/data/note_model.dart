class NoteModel {
  final int id;
  final int userId;
  final int? assetId;
  final String? assetSymbol;
  final String? assetName;
  final String title;
  final String body;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  const NoteModel({
    required this.id,
    required this.userId,
    this.assetId,
    this.assetSymbol,
    this.assetName,
    required this.title,
    required this.body,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'] as int,
        userId: json['userId'] as int,
        assetId: json['assetId'] as int?,
        assetSymbol: json['assetSymbol'] as String?,
        assetName: json['assetName'] as String?,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
        updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      );
}
