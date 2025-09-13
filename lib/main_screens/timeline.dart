import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/services_view.dart';
import 'package:my_governate_app/main_screens/tourism_view.dart';
import 'package:my_governate_app/main_screens/traffics_view.dart';
import 'package:my_governate_app/services/api.dart';
import 'package:my_governate_app/widgets/custom_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final OpenTriMapsCalls _apiCaller = OpenTriMapsCalls();

  bool _isLoading = true;
  String? _errorMessage;

  List tourismPosts = [];
  List servicesPosts = [];
  List trafficsPosts = [];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  /// Loads data from API and sets up posts
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cairoData = await _apiCaller.fetchCairoData();
      List placeInfo = [];

      //This stores the xids(a unique ID for each place that shows more details about the place)
      List xIds = [];
      for (var xid in cairoData['features']) {
        if (xid['properties']?['xid'] != null) {
          xIds.add(xid['properties']['xid']);
        }
      }

      //This is calling the api endpoint that gets more details about the place
      //This stores the data of each place in the placeInfo list
      for (var xid in xIds) {
        try {
          var data = await _apiCaller.fetchPlaceInfo(xid);
          placeInfo.add(data);
        } catch (e) {
          print("Couldn't fetch data: $e");
          placeInfo.add(null);
        }
      }

      if (cairoData != null && cairoData['features'] is List) {
        final features = cairoData['features'] as List;

        final mappedTourismPosts = [];
        for (int i = 0; i < features.length; i++) {
          String description = "Description not available at the moment";
          String image =
              'assets/images/Missing-Image.png';
          String rating = '';
          if (i < placeInfo.length && placeInfo[i] != null) {
            var details = placeInfo[i];
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
          servicesPosts = [
            {
              "title": "Takeaway restaurant",
              "imagePath": "assets/images/restaurant.png",
              "rate": 2.1,
              "numOfVotes": 40,
              "lat": 30.056,
              "lng": 31.234,
              "content": "content"
            },
            {
              "title": "Balady Cafe",
              "imagePath": "assets/images/little_shop.jpeg",
              "rate": 2.99,
              "numOfVotes": 42,
              "lat": 30.066,
              "lng": 31.220,
              "content": "content"
            },
          ];
          trafficsPosts = [
            {
              "title": "Ramsis station",
              "imagePath": "assets/images/ramsis.png",
              "rate": 4.7,
              "numOfVotes": 50,
              "lat": 30.061,
              "lng": 31.246,
              "content": "content"
            },
            {
              "title": "Traffic Point",
              "imagePath": "assets/images/little_shop.jpeg",
              "rate": 4.7,
              "numOfVotes": 10,
              "lat": 30.051,
              "lng": 31.210,
              "content": "content"
            },
          ];
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
              IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh)),
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
                  TourismView(
                    tourismPosts: tourismPosts,
                  ),
                  ServicesView(
                    servicesPosts: servicesPosts,
                    onPostTap: _navigateToMap,
                  ),
                  TrafficsView(
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
