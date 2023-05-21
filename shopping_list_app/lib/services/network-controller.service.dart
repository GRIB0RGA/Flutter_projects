import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_list/constants/firebase.dart';

class NetworkControllerService {
  Future<http.Response> getGroceries() async {
    return await http.get(Uri.https(authorityUrl, 'shopping-list.json'));
  }

  Future<http.Response> deleteGroceryItem(String id) async {
    return await http.delete(Uri.https(authorityUrl, 'shopping-list/$id.json'));
  }

  Future<http.Response> addGroceryItem({required String name,required int quantity,required String category}) async {
    final request = {'name': name,'quantity': quantity,'category': category};
    return await http.post(Uri.https(authorityUrl, 'shopping-list.json'),headers: {'Content-Type': 'application/json'},body: json.encode(request),);
  }
}
