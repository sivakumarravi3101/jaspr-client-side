import 'package:trade_intelligence/services/api/api_client.dart';
import 'package:trade_intelligence/services/api/list_response.dart';

import '../models/lookup_option.dart';
import '../models/export_product.dart';

class ExportProductService {
  ExportProductService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<LookupOption>> getCountries() => _getLookupOptions('countries');

  Future<List<LookupOption>> getCategories() => _getLookupOptions('categories');

  Future<ListResponse<ExportProduct>> getProducts({
    required String filter,
    required int top,
    required int skip,
  }) async {
    final response = await _apiClient.get(
      'products',
      queryParameters: {
        if (filter.isNotEmpty) r'$filter': filter,
        r'$top': top,
        r'$skip': skip,
      },
    );
    return ListResponse<ExportProduct>.fromJson(response, ExportProduct.fromJson);
  }

  Future<List<LookupOption>> _getLookupOptions(String path) async {
    final response = await _apiClient.getList(path);
    return response
        .map((item) {
          if (item is! Map) {
            throw FormatException('The $path response contains an invalid option.');
          }
          return LookupOption.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }
}
