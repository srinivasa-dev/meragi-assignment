import 'package:http/http.dart';


class ItemsService {
  String baseUrl = 'https://fakestoreapi.com/products';

  Future<Response> getItems() async {
    final response = await get(Uri.parse(baseUrl),);

    return response;
  }
}