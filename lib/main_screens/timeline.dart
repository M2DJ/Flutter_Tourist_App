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

    _loadPlaceData();
  }

  Future _loadPlaceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      //This is for calling the API
      var cairoTourismData = await _apiCaller.fetchCairoData();
      final List cairoXid = [];
      
      final List<Map> cairoContent = [];

      //This is for adding every xid of every place in cairo into a List
      for (var xid in cairoTourismData['features']) {
        cairoXid.add(xid['properties']['xid']);
      }

      for (var xid in cairoXid) {
        try {
          var content = await _apiCaller.fetchStateInfo(xid);
          cairoContent.add(content);
        } catch (e) {
          print(e);
          cairoContent.add({"text": 'No description available'});
        }
      }

      if (cairoTourismData != null && cairoTourismData['features'] is List) {
        List features = cairoTourismData['features'];
        List content = [];
        for (var place in cairoContent) {
          if (place['wikipedia_extracts'] != null) {
            content.add(place['wikipedia_extracts']['text']);
          } else {
            content.add("No description available.");
          }
        }

        int index = 0;
        List mappedTourismPosts = features.map((feature) {
          var post = {
            "title": feature['properties']['name'] ?? 'Unnamed Place',
            "imagePath": 'assets/images/Pyramids.png',
            "rate": (feature['properties']['rate'] ?? 0.0),
            "numOfVotes": 0,
            "content": index < content.length
                ? content[index]
                : "No description available",
            "xid": feature['properties']['xid'],
          };
          index++;

          return post;
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
    // {
    //   "title": "Takeaway restaurent",
    //   "imagePath": "assets/images/restaurant.png",
    //   "rate": 2.1,
    //   "numOfVotes": 40,
    //   "content": "content"
    // },
    // {
    //   "title": "Balady Cafe",
    //   "imagePath": "assets/images/little_shop.jpeg",
    //   "rate": 2.99,
    //   "numOfVotes": 42,
    //   "content": "content"
    // },
  ];
  List trafficsPosts = [
    // {
    //   "title": "Ramsis station",
    //   "imagePath": "assets/images/ramsis.png",
    //   "rate": 4.7,
    //   "numOfVotes": 50,
    //   "content": "content"
    // },
    // {
    //   "title": "Balady Cafe",
    //   "imagePath": "assets/images/little_shop.jpeg",
    //   "rate": 4.7,
    //   "numOfVotes": 10,
    //   "content": "content"
    // },
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
            IconButton(
                onPressed: _loadPlaceData, icon: const Icon(Icons.refresh)),
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
