import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaImageProvider {
  Future fetchPlaceImage(String placeName) async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$placeName'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          "Failed to load data: ${response.statusCode} ${response.body}");
    }
  }
}
