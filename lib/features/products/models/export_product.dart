class ExportProduct {
  const ExportProduct({
    required this.id,
    required this.createdAt,
    required this.state,
    required this.port,
    required this.productId,
    required this.countryId,
    required this.year,
    required this.value,
    required this.quantity,
    required this.countryName,
    required this.categoryName,
    required this.hsCode,
    required this.categoryId,
    required this.productName,
  });

  final int id;
  final String createdAt;
  final String state;
  final String port;
  final int productId;
  final int countryId;
  final String year;
  final num value;
  final num quantity;
  final String countryName;
  final String categoryName;
  final String hsCode;
  final int categoryId;
  final String productName;

  factory ExportProduct.fromJson(Map<String, dynamic> json) {
    return ExportProduct(
      id: _requiredInt(json, 'id'),
      createdAt: _requiredString(json, 'createdAt'),
      state: _requiredString(json, 'state'),
      port: _requiredString(json, 'port'),
      productId: _requiredInt(json, 'productId'),
      countryId: _requiredInt(json, 'countryId'),
      year: _requiredString(json, 'year'),
      value: _requiredNum(json, 'productValue'),
      quantity: _requiredNum(json, 'quantity'),
      countryName: _requiredString(json, 'countryName'),
      categoryName: _requiredString(json, 'categoryName'),
      hsCode: _requiredString(json, 'hsCode'),
      categoryId: _requiredInt(json, 'categoryId'),
      productName: _requiredString(json, 'productName'),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Export product is missing a valid $key value.');
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Export product is missing a valid $key value.');
  }

  static num _requiredNum(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num) return value;
    throw FormatException('Export product is missing a valid $key value.');
  }
}
