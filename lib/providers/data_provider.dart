import 'package:flutter/material.dart';
import 'package:my_governate_app/services/api.dart';

class DataProvider extends ChangeNotifier {
  final _apiCaller = OpenTriMapsCalls();

  final List _tourismPosts = [];
  final List _servicesPosts = [];
  final List _trafficsPosts = [];

  Future loadTourismData(String state) async {
    try {
      final tourismData = await _apiCaller.fetchData(
          state: state, kindsFilter: 'interesting_places');
      List tourismInfo = [];

      //This stores the xids(a unique ID for each place that shows more details about the place)
      List xIds = [];
      for (var xid in tourismData['features']) {
        if (xid['properties']?['xid'] != null) {
          xIds.add(xid['properties']['xid']);
        }
      }

      //This is calling the api endpoint that gets more details about the place
      //This stores the data of each place in the placeInfo list
      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          tourismInfo.add(data);
        } catch (e) {
          print("Couldn't fetch data: $e");
          tourismInfo.add(null);
        }
      }

      if (tourismData != null && tourismData['features'] is List) {
        final features = tourismData['features'] as List;

        final mappedTourismPosts = [];
        for (int i = 0; i < features.length; i++) {
          String description = "Description not available at the moment";
          String image = 'assets/images/Missing-Image.png';
          String rating = '';
          if (i < tourismInfo.length && tourismInfo[i] != null) {
            var details = tourismInfo[i];
            description = details['wikipedia_extracts']?['text'] ??
                "Description not available";
            if (details['image'] != null && details['image'] is String) {
              image = details['image'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/3/33/Image-missing.svg';
            }
            if (details['rate'] != null) {
              rating = details['rate'] ?? '0.0';
            }
          }

          mappedTourismPosts.add({
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            "imagePath": image,
            "rate": rating,
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": description,
          });
        }
        _tourismPosts.addAll(mappedTourismPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  Future loadServicesData(String state) async {
    try {
      final servicesData =
          await _apiCaller.fetchData(state: state, kindsFilter: 'foods');
      List servicesInfo = [];

      //This stores the xids(a unique ID for each place that shows more details about the place)
      List xIds = [];
      for (var xid in servicesData['features']) {
        if (xid['properties']?['xid'] != null) {
          xIds.add(xid['properties']['xid']);
        }
      }

      //This is calling the api endpoint that gets more details about the place
      //This stores the data of each place in the placeInfo list
      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          servicesInfo.add(data);
        } catch (e) {
          print("Couldn't fetch data: $e");
          servicesInfo.add(null);
        }
      }

      if (servicesData != null && servicesData['features'] is List) {
        final features = servicesData['features'] as List;

        final mappedServicesPosts = [];
        for (int i = 0; i < features.length; i++) {
          String description = "Description not available at the moment";
          String image = 'assets/images/Missing-Image.png';
          String rating = '';
          if (i < servicesInfo.length && servicesInfo[i] != null) {
            var details = servicesInfo[i];
            description = details['wikipedia_extracts']?['text'] ??
                "Description not available";
            if (details['image'] != null && details['image'] is String) {
              image = details['image'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/3/33/Image-missing.svg';
            }
            if (details['rate'] != null) {
              rating = details['rate'] ?? '0.0';
            }
          }

          mappedServicesPosts.add({
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            "imagePath": image,
            "rate": rating,
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": description,
          });
        }
        _servicesPosts.addAll(mappedServicesPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  Future loadTrafficData(String state) async {
    try {
      final trafficData =
          await _apiCaller.fetchData(state: state, kindsFilter: 'transport');
      List trafficInfo = [];

      //This stores the xids(a unique ID for each place that shows more details about the place)
      List xIds = [];
      for (var xid in trafficData['features']) {
        if (xid['properties']?['xid'] != null) {
          xIds.add(xid['properties']['xid']);
        }
      }

      //This is calling the api endpoint that gets more details about the place
      //This stores the data of each place in the placeInfo list
      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          trafficInfo.add(data);
        } catch (e) {
          print("Couldn't fetch data: $e");
          trafficInfo.add(null);
        }
      }

      if (trafficData != null && trafficData['features'] is List) {
        final features = trafficData['features'] as List;

        final mappedTrafficPosts = [];
        for (int i = 0; i < features.length; i++) {
          String description = "Description not available at the moment";
          String image = 'assets/images/Missing-Image.png';
          String rating = '';
          if (i < trafficInfo.length && trafficInfo[i] != null) {
            var details = trafficInfo[i];
            description = details['wikipedia_extracts']?['text'] ??
                "Description not available";
            if (details['image'] != null && details['image'] is String) {
              image = details['image'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/3/33/Image-missing.svg';
            }
            if (details['rate'] != null) {
              rating = details['rate'] ?? '0.0';
            }
          }

          mappedTrafficPosts.add({
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            "imagePath": image,
            "rate": rating,
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": description,
          });
        }
        _trafficsPosts.addAll(mappedTrafficPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  List get getTourismPosts => _tourismPosts;
  List get getServicesPosts => _servicesPosts;
  List get getTrafficPosts => _trafficsPosts;
  
}
