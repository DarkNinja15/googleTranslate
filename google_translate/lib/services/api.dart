import 'dart:convert';
import 'package:google_translate/imp_keys.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<String>> fetchLanguages() async {
    List<String> languages = [];
    final response = await http.get(
      Uri.parse(endpointFetch),
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

  Future<String> translateText(
      String text, String targetLanguage, String sourceLanguage) async {
    final response = await http.post(
      Uri.parse(
          "https://google-translate1.p.rapidapi.com/language/translate/v2"),
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'Accept-Encoding': 'application/gzip',
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'google-translate1.p.rapidapi.com',
      },
      body: {
        'q': text,
        'target': targetLanguage,
        'source': sourceLanguage,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['data']['translations'][0]['translatedText'];
    } else {
      print(response.statusCode);
      print(response.body);
      return "(())";
      throw Exception('Failed to fetch translation');
    }
  }
}
