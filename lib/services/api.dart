import 'dart:convert';
import 'package:http/http.dart' as http;

//Used OpenTriMap API cause the Google API required a billing account(I don't have one lol)
class OpenTriMapsCalls {
  //for the api calls, It needs an API key
  Future fetchCairoData() async {
    final response = await http.get(Uri.parse(
        'https://api.opentripmap.com/0.1/en/places/radius?radius=10000&lon=31.2357&lat=30.0444&rate=3&apikey=5ae2e3f221c38a28845f05b67fab4081ee576015481168cceca5fa5b'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  /*
    This is what the call returns:
    {
  "type": "FeatureCollection",
  "features": [
      {
        "type": "Feature",
        "id": "way:123456789",
        "geometry": {
          "type": "Point",
          "coordinates": [31.1375, 29.9750] // [longitude, latitude]
        },
        "properties": {
          "xid": "12345abcde67890", // The unique ID for the detailed call
          "name": "The Egyptian Museum in Cairo",
          "rate": 7, // Importance rating (1-7)
          "osm": "way/123456789", // OpenStreetMap ID
          "kinds": "museums,cultural,history", // Comma-separated categories
          "wikidata": "Q19675", // Wikidata identifier
          "dist": 1250.75 // Distance from your search point in meters
          // Note: 'image' or 'description' are NOT in this preview object
        }
      },
      {
        "type": "Feature",
        "id": "node:987654321",
        "geometry": {
        "type": "Point",
        "coordinates": [31.1343, 29.9792]
        },
        "properties": {
          "xid": "fghij67890klmno",
          "name": "Tahrir Square",
          "rate": 5,
          "osm": "node/987654321",
          "kinds": "historic,urban_environment,squares",
          "wikidata": "Q12345",
          "dist": 980.20
        }
      }
      // ... more features ...
      ]
    }
  */

  /*
    This call is made to get more details about the place like: rating, images and description
  */
  Future fetchStateInfo(var xid) async {
    final response = await http.get(Uri.parse(
        'https://api.opentripmap.com/0.1/en/places/xid/$xid?apikey=5ae2e3f221c38a28845f05b67fab4081ee576015481168cceca5fa5b'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  /*
    This is the returned object:
    {
      "xid": "12345abcde",
      "name": "The Egyptian Museum",
      "address": {
        "city": "Cairo",
        "state": "Cairo Governorate"
      },
      "rate": 3,
      "osm": "way/123456789",
      "wikipedia": "en:Egyptian Museum",
      "image": "https://upload.wikimedia.org/.../Egyptian_Museum_01.jpg",
      "wikidata": "Q19675",
      "kinds": "museums,cultural,history",
      "url": "http://www.egyptianmuseum.gov.eg/",
      "otm": "https://opentripmap.com/en/card/12345abcde",
      "info": {
        "descr": "The Museum of Egyptian Antiquities, known commonly as the Egyptian Museum, is home to an extensive collection of ancient Egyptian antiquities. It has 120,000 items...",
        "image": "https://upload.wikimedia.org/.../Egyptian_Museum_01.jpg"
      },
      "point": {
        "lon": 31.2336,
        "lat": 30.0478
      }
    }
  */
}
