import 'dart:convert';
import 'package:http/http.dart' as http;

//Used OpenTriMap API cause the Google API required a billing account(I don't have one lol)
class OpenTriMapsCalls {
  Future fetchCairoData() async {
    final response = await http.get(Uri.parse(
        'https://api.opentripmap.com/0.1/en/places/radius?radius=10000&lon=31.2357&lat=30.0444&rate=3&apikey=5ae2e3f221c38a28845f05b67fab4081ee576015481168cceca5fa5b'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future fetchPlaceData(var xid) async {
    final response = await http.get(Uri.parse(
        'https://api.opentripmap.com/0.1/en/places/xid/$xid?apikey=5ae2e3f221c38a28845f05b67fab4081ee576015481168cceca5fa5b'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
