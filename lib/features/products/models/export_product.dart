class ExportProduct {
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

  factory ExportProduct.fromJson(Map<String, dynamic> json) {
    return ExportProduct(
      id: json['id'] as int,
      createdAt: json['createdAt'] as String,
      state: json['state'] as String,
      port: json['port'] as String,
      productId: json['productId'] as int,
      countryId: json['countryId'] as int,
      year: json['year'] as String,
      value: json['value'] as num,
      quantity: json['quantity'] as num,
      countryName: json['countryName'] as String,
      categoryName: json['categoryName'] as String,
      hsCode: json['hsCode'] as String,
      categoryId: json['categoryId'] as int,
      productName: json['productName'] as String,
    );
  }
}
