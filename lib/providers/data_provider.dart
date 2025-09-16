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
            "imagePath": 'assets/images/Missing-image.png',
            "rate": "0",
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": '',
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
        final updatedPost = Map<String, dynamic>.from(_tourismPosts[index]);

        if (tourismInfo['image'] != null) {
          updatedPost["imagePath"] = tourismInfo['image'];
        }
        if (tourismInfo['rate'] != null) {
          updatedPost["rate"] = tourismInfo['rate'];
        }
        if (tourismInfo['wikipedia_extracts']?['text'] != null) {
          updatedPost["content"] = tourismInfo['wikipedia_extracts']['text'];
        }

        _tourismPosts[index] = updatedPost;
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
            "imagePath": 'assets/images/Missing-image.png',
            "rate": "0",
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": '',
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
        final updatedPost = Map<String, dynamic>.from(_tourismPosts[index]);

        if (servicesInfo['image'] != null) {
          updatedPost["imagePath"] = servicesInfo['image'];
        }
        if (servicesInfo['rate'] != null) {
          updatedPost["rate"] = servicesInfo['rate'];
        }
        if (servicesInfo['wikipedia_extracts']?['text'] != null) {
          updatedPost["content"] = servicesInfo['wikipedia_extracts']['text'];
        }

        _servicesPosts[index] = updatedPost;
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
            "imagePath": 'assets/images/Missing-image.png',
            "rate": "0",
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": '',
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
         final updatedPost = Map<String, dynamic>.from(_tourismPosts[index]);

        if (trafficInfo['image'] != null) {
          updatedPost["imagePath"] = trafficInfo['image'];
        }
        if (trafficInfo['rate'] != null) {
          updatedPost["rate"] = trafficInfo['rate'];
        }
        if (trafficInfo['wikipedia_extracts']?['text'] != null) {
          updatedPost["content"] = trafficInfo['wikipedia_extracts']['text'];
        }

        _trafficsPosts[index] = updatedPost;
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
