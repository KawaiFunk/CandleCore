class PagedList<T> {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final List<T> data;

  const PagedList({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.data,
  });

  factory PagedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedList<T>(
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
    );
  }
}

class PagedListFilter {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final bool descending;

  const PagedListFilter({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.search,
    this.sortBy,
    this.descending = false,
  });

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'search': search,
    'sortBy': sortBy,
    'descending': descending,
  };
}
