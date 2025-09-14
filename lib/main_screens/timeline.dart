import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/services_view.dart';
import 'package:my_governate_app/main_screens/tourism_view.dart';
import 'package:my_governate_app/main_screens/traffics_view.dart';
import 'package:my_governate_app/provider/state_provider.dart';
import 'package:my_governate_app/services/api.dart';
import 'package:my_governate_app/widgets/custom_tab.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  List tourismPosts = [];
  List servicesPosts = [];
  List trafficsPosts = [];

  @override
  void initState() {
    super.initState();
    _loadTourismData();
    _loadServicesData();
    _loadTrafficData();
  }

  /// Loads data from API and sets up posts
  Future<void> _loadTourismData() async {
    final stateProvider = Provider.of<StateProvider>(context, listen: false);
    OpenTriMapsCalls _apiCaller = OpenTriMapsCalls(stateProvider);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tourismData = await _apiCaller.fetchData(state: stateProvider.state);
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

        setState(() {
          tourismPosts = mappedTourismPosts;
          _isLoading = false;
        });
      } else {
        throw Exception('Data format is incorrect');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load attractions. Tap to retry.';
      });
      debugPrint('Error loading data: $e');
    }
  }

  Future<void> _loadServicesData() async {
    final stateProvider = Provider.of<StateProvider>(context, listen: false);
    OpenTriMapsCalls _apiCaller = OpenTriMapsCalls(stateProvider);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      //This api call fetches all the resaurants and cafes
      final servicesData = await _apiCaller.fetchData(state: stateProvider.state, kindsFilter: 'foods');
      List servicesInfo = [];

      List xIds = [];
      for (var xid in servicesData['features']) {
        if (xid["properties"]?["xid"] != null) {
          xIds.add(xid["properties"]["xid"]);
        }
      }

      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          servicesInfo.add(data);
        } catch (e) {
          print("Couldn't get place info due to an error: $e");
          servicesInfo.add(null);
        }
      }

      if (servicesData != null && servicesData['features'] is List) {
        final features = servicesData['features'] as List;

        final mappedservicesPosts = [];
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

          mappedservicesPosts.add({
            "title": features[i]['properties']['name'] ?? 'Unnamed Place',
            "imagePath": image,
            "rate": rating,
            "numOfVotes": 0,
            "lat": features[i]['geometry']['coordinates'][1],
            "lng": features[i]['geometry']['coordinates'][0],
            "content": description,
          });
        }

        setState(() {
          servicesPosts = mappedservicesPosts;
          _isLoading = false;
        });
      } else {
        throw Exception('Data format is incorrect');
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load attractions. Tap to retry.';
      });
      debugPrint('Error loading data: $e');
    }
  }

  Future<void> _loadTrafficData() async {
    final stateProvider = Provider.of<StateProvider>(context, listen: false);
    OpenTriMapsCalls _apiCaller = OpenTriMapsCalls(stateProvider);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      //This api call fetches all the train and bus stations
      final trafficData = await _apiCaller.fetchData(state: stateProvider.state, kindsFilter: 'transport');
      List trafficInfo = [];

      List xIds = [];
      for (var xid in trafficData['features']) {
        if (xid["properties"]?["xid"] != null) {
          xIds.add(xid["properties"]["xid"]);
        }
      }

      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          trafficInfo.add(data);
        } catch (e) {
          print("Couldn't get place info due to an error: $e");
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

        setState(() {
          trafficsPosts = mappedTrafficPosts;
          _isLoading = false;
        });
      } else {
        throw Exception('Data format is incorrect');
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load attractions. Tap to retry.';
      });
      debugPrint('Error loading data: $e');
    }
  }

  /// Opens Maps with coordinates
  void _navigateToMap(double lat, double lng) async {
    final Uri url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              const SizedBox(height: 10),
              IconButton(
                  onPressed: _loadTourismData, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/Explore sentence.png"),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xffD4D6DD)),
                ],
              ),
            ),
            // Tabs
            Container(
              margin: EdgeInsets.zero,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
                indicator: BoxDecoration(
                  color: const Color(0xff3174F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: const [
                  CustomTab(text: "Tourism"),
                  CustomTab(text: "Services"),
                  CustomTab(text: "Traffics"),
                ],
              ),
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  tourismPosts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('No data availible at the moment')],
                          ),
                        )
                      : TourismView(
                          tourismPosts: tourismPosts,
                        ),
                  servicesPosts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('No data availible at the moment')],
                          ),
                        )
                      : ServicesView(
                          servicesPosts: servicesPosts,
                          onPostTap: _navigateToMap,
                        ),
                  trafficsPosts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('No data availible at the moment')],
                          ),
                        )
                      : TrafficsView(
                          trafficsPosts: trafficsPosts,
                          onPostTap: _navigateToMap,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
