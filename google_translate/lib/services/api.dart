import 'dart:convert';
import 'package:google_translate/imp_keys.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<String>> fetchLanguages() async {
    List<String> languages = [];
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'Accept-Encoding': 'application/gzip',
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'google-translate1.p.rapidapi.com',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var d = data['data']['languages'];
      for (var e in d) {
        languages.add(e['language']);
      }
      return languages;
    } else {
      throw Exception('Failed to fetch languages');
    }
  }
}
