import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/services_view.dart';
import 'package:my_governate_app/main_screens/tourism_view.dart';
import 'package:my_governate_app/main_screens/traffics_view.dart';
import 'package:my_governate_app/services/api.dart';
import 'package:my_governate_app/widgets/custom_tab.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final OpenTriMapsCalls _apiCaller = OpenTriMapsCalls();

  bool _isLoading = true;

  String? _errorMessage;

  void initState() {
    super.initState();

    _loadData();
  }

  Future _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var cairoData = await _apiCaller.fetchCairoData();

      if (cairoData != null && cairoData['features'] is List) {
        List features = cairoData['features'];
        
        List mappedTourismPosts = features.map((feature) {
          return {
            "title": feature['properties']['name'] ?? 'Unnamed Place',
            "imagePath": 'assets/images/Pyramids.png',
            "rate": (feature['properties']['rate'] ?? 0.0),
            "numOfVotes": 0,
            "content": "Description not loaded yet."
          };
        }).toList();

        setState(() {
          tourismPosts = mappedTourismPosts;
          servicesPosts = [
            {
              "title": "Takeaway restaurent",
              "imagePath": "assets/images/restaurant.png",
              "rate": 2.1,
              "numOfVotes": 40,
              "content": "content"
            },
            {
              "title": "Balady Cafe",
              "imagePath": "assets/images/little_shop.jpeg",
              "rate": 2.99,
              "numOfVotes": 42,
              "content": "content"
            },
          ];
          trafficsPosts = [
            {
              "title": "Ramsis station",
              "imagePath": "assets/images/ramsis.png",
              "rate": 4.7,
              "numOfVotes": 50,
              "content": "content"
            },
            {
              "title": "Balady Cafe",
              "imagePath": "assets/images/little_shop.jpeg",
              "rate": 4.7,
              "numOfVotes": 10,
              "content": "content"
            },
          ];
          _isLoading = false;
        });
      } else {
        print('Data format is incorrect or features is not a list');
        throw Exception('Data format is incorrect');
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load attractions. Tap to retry';
      });
      print(e);
    }
  }

  List tourismPosts = [];
  List servicesPosts = [
    {
      "title": "Takeaway restaurent",
      "imagePath": "assets/images/restaurant.png",
      "rate": 2.1,
      "numOfVotes": 40,
      "content": "content"
    },
    {
      "title": "Balady Cafe",
      "imagePath": "assets/images/little_shop.jpeg",
      "rate": 2.99,
      "numOfVotes": 42,
      "content": "content"
    },
  ];
  List trafficsPosts = [
    {
      "title": "Ramsis station",
      "imagePath": "assets/images/ramsis.png",
      "rate": 4.7,
      "numOfVotes": 50,
      "content": "content"
    },
    {
      "title": "Balady Cafe",
      "imagePath": "assets/images/little_shop.jpeg",
      "rate": 4.7,
      "numOfVotes": 10,
      "content": "content"
    },
  ];

  @override
  Widget build(BuildContext context) {
    //To show a loading indicator when fething the data
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    //To show the error message if there is any
    if (_errorMessage != null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh)),
          ],
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
            Expanded(
              child: TabBarView(
                children: [
                  TourismView(tourismPosts: tourismPosts),
                  ServicesView(servicesPosts: servicesPosts),
                  TrafficsView(trafficsPosts: trafficsPosts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
