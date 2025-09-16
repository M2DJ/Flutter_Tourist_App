import 'package:flutter/material.dart';
import 'package:my_governate_app/services/api.dart';

class DataProvider extends ChangeNotifier {
  final _apiCaller = OpenTriMapsCalls();

  late var tourismData;
  late var servicesData;
  late var trafficData;
  List tourismXid = [];
  List servicesXid = [];
  List trafficXid = [];

  final List _tourismPosts = [];
  final List _servicesPosts = [];
  final List _trafficsPosts = [];

  Future loadTourismData(String state) async {
    try {
      tourismData = await _apiCaller.fetchData(
          state: state, kindsFilter: 'interesting_places');

      //This stores the xids(a unique ID for each place that shows more details about the place)
      for (var xid in tourismData['features']) {
        if (xid['properties']?['xid'] != null) {
          tourismXid.add(xid['properties']['xid']);
        }
      }

      if (tourismData != null && tourismData['features'] is List) {
        final features = tourismData['features'] as List;

        final mappedTourismPosts = [];
        for (int i = 0; i < features.length; i++) {
          mappedTourismPosts.add({
            "id": features[i]['properties']['xid'],
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            // "imagePath": image,
            // "rate": rating,
            // "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            // "content": description,
          });
        }
        _tourismPosts.addAll(mappedTourismPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future loadTourismInfo(var xid) async {
    Map tourismInfo;

    try {
      tourismInfo = await _apiCaller.fetchPlaceInfo(xid);

      final index = _tourismPosts.indexWhere((post) => post['id'] == xid);
      if (index != -1) {
        _tourismPosts[index]["imagePath"] =
            tourismInfo['image'] ?? 'assets/images/Missing-Image.png';
        _tourismPosts[index]["rate"] = tourismInfo['rate'] ?? '0';
        _tourismPosts[index]["numOfVotes"] = 0;
        _tourismPosts[index]["content"] = tourismInfo['wikipedia_extract']
                ?['text'] ??
            "No description available at the moment";
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future loadServicesData(String state) async {
    try {
      servicesData =
          await _apiCaller.fetchData(state: state, kindsFilter: 'foods');

      //This stores the xids(a unique ID for each place that shows more details about the place)
      for (var xid in servicesData['features']) {
        if (xid['properties']?['xid'] != null) {
          servicesXid.add(xid['properties']['xid']);
        }
      }

      if (servicesData != null && servicesData['features'] is List) {
        final features = servicesData['features'] as List;

        final mappedServicesPosts = [];
        for (int i = 0; i < features.length; i++) {
          mappedServicesPosts.add({
            "id": features[i]['properties']['xid'],
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            // "imagePath": image,
            // "rate": rating,
            // "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            // "content": description,
          });
        }
        _servicesPosts.addAll(mappedServicesPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future loadServicesInfo(var xid) async {
    Map servicesInfo;

    try {
      servicesInfo = await _apiCaller.fetchPlaceInfo(xid);

      final index = _servicesPosts.indexWhere((post) => post['id'] == xid);
      if (index != -1) {
        _servicesPosts[index]["imagePath"] =
            servicesInfo['image'] ?? 'assets/images/Missing-Image.png';
        _servicesPosts[index]["rate"] = servicesInfo['rate'] ?? '0';
        _servicesPosts[index]["numOfVotes"] = 0;
        _servicesPosts[index]["content"] = servicesInfo['wikipedia_extract']
                ?['text'] ??
            "No description available at the moment";
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future loadTrafficData(String state) async {
    try {
      trafficData =
          await _apiCaller.fetchData(state: state, kindsFilter: 'transport');

      for (var xid in trafficData['features']) {
        if (xid['properties']?['xid'] != null) {
          trafficXid.add(xid['properties']['xid']);
        }
      }

      if (trafficData != null && trafficData['features'] is List) {
        final features = trafficData['features'] as List;

        final mappedTrafficPosts = [];
        for (int i = 0; i < features.length; i++) {
          mappedTrafficPosts.add({
            "id": features[i]['properties']['xid'],
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            // "imagePath": image,
            // "rate": rating,
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            // "content": description,
          });
        }
        _trafficsPosts.addAll(mappedTrafficPosts);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future loadTrafficInfo(xid) async {
    Map trafficInfo;

    try {
      trafficInfo = await _apiCaller.fetchPlaceInfo(xid);

      final index = _trafficsPosts.indexWhere((post) => post['id'] == xid);
      if (index != -1) {
        _trafficsPosts[index]["imagePath"] =
            trafficInfo['image'] ?? 'assets/images/Missing-Image.png';
        _trafficsPosts[index]["rate"] = trafficInfo['rate'] ?? '0';
        _trafficsPosts[index]["numOfVotes"] = 0;
        _trafficsPosts[index]["content"] = trafficInfo['wikipedia_extract']
                ?['text'] ??
            "No description available at the moment";
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
