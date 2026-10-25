class ListResponse<T> {
  const ListResponse({
    required this.items,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  final List<T> items;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final rawItems = json['items'];
    if (rawItems is! List) {
      throw const FormatException('The list response is missing an items array.');
    }

    return ListResponse<T>(
      items: rawItems
          .map((item) {
            if (item is! Map) {
              throw const FormatException('The list response contains an invalid item.');
            }
            return fromJson(Map<String, dynamic>.from(item));
          })
          .toList(growable: false),
      totalCount: _requiredInt(json, 'totalCount'),
      pageIndex: _requiredInt(json, 'pageIndex'),
      pageSize: _requiredInt(json, 'pageSize'),
    );
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('The list response is missing a valid $key value.');
  }
}
