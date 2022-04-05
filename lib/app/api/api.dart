import 'package:http/http.dart' as http;
import 'package:pv_test/app/constant/string.dart';

class BaseAPI {
  Future<http.Response> getAPI({int page}) async {
    var url = '${AppText.baseUrl}${AppText.apiKey}&page=$page';
    var response = await http.get(url);
    return response;
  }
}
