import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';
import '../../../core/models/paged_list.dart';
import 'asset_model.dart';

class AssetService {
  Future<PagedList<AssetModel>> fetchAssets(PagedListFilter filter) async {
    final baseUrl = Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106');
    final uri = Uri.parse('$baseUrl/api/assets?pageNumber=${filter.pageNumber}&pageSize=${filter.pageSize}');


    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load assets');
    }

    final json = jsonDecode(response.body);
    return PagedList.fromJson(json, (e) => AssetModel.fromJson(e));
  }
}
