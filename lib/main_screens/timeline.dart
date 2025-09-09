import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/services_view.dart';
import 'package:my_governate_app/main_screens/tourism_view.dart';
import 'package:my_governate_app/main_screens/traffics_view.dart';
import 'package:my_governate_app/widgets/custom_tab.dart';


class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary static list
    //replace this with data from API or state management later
    final tourismPosts = [
      {
        "title": "Giza Pyramid",
        "imagePath": "assets/images/Pyramids.png",
        "rate": 4.7,
        "numOfVotes": 40,
        "content":
            "The Pyramids of Giza are Egypt’s most iconic monuments and one of the world’s greatest historical treasures. Built over 4,500 years ago as royal tombs for the Pharaohs, they include the Great Pyramid of Khufu, the Pyramid of Khafre, and the smaller Pyramid of Menkaure. Together with the mysterious Sphinx, they stand as a symbol of ancient Egyptian civilization and continue to attract millions of visitors from around the globe."
      },
      {
        "title": "Balady Cafe",
        "imagePath": "assets/images/little_shop.jpeg",
        "rate": 3.78,
        "numOfVotes": 20,
        "content": "content"
      },
    ];
    final servicesPosts = [
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
    final trafficsPosts = [
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
