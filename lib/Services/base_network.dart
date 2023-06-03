import 'package:http/http.dart' as http;
import 'dart:convert';


class BaseNetwork {
  final String baseUrl = 'http://www.omdbapi.com/?apikey=311570e5?=';

  Future<dynamic> get(String endpoint) async {
    final url = '$baseUrl$endpoint';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }
