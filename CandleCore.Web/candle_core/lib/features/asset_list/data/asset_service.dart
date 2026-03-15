import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';
import '../../../core/models/paged_list.dart';
import 'asset_model.dart';

class AssetService {
  String get _baseUrl => Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106');

  Future<PagedList<AssetModel>> fetchAssets(PagedListFilter filter) async {
    final params = {
      'pageNumber': '${filter.pageNumber}',
      'pageSize': '${filter.pageSize}',
      if (filter.search != null && filter.search!.isNotEmpty)
        'search': filter.search!,
    };

    final uri = Uri.parse('$_baseUrl/api/assets').replace(
      queryParameters: params,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load assets');
    }

    final json = jsonDecode(response.body);
    return PagedList.fromJson(json, (e) => AssetModel.fromJson(e));
  }
}
