import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/services_view.dart';
import 'package:my_governate_app/main_screens/tourism_view.dart';
import 'package:my_governate_app/main_screens/traffics_view.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:my_governate_app/providers/app_state_provider.dart';
import 'package:my_governate_app/widgets/custom_tab.dart';
import 'package:provider/provider.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();

    loadTourismPosts();
    loadServicesPosts();
    loadTrafficPosts();
  }

  Future<void> loadTourismPosts() async {
    setState(() {
      loading = true;
    });

    final stateProvider = Provider.of<AppStateProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    await dataProvider.loadTourismData(stateProvider.selectedState);

    setState(() {
      loading = false;
    });
  }

  Future<void> loadServicesPosts() async {
    setState(() {
      loading = true;
    });

    final stateProvider = Provider.of<AppStateProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    await dataProvider.loadServicesData(stateProvider.selectedState);

    setState(() {
      loading = false;
    });
  }

  Future<void> loadTrafficPosts() async {
    setState(() {
      loading = true;
    });

    final stateProvider = Provider.of<AppStateProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    await dataProvider.loadTrafficData(stateProvider.selectedState);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = context.watch<DataProvider>();

    final tourismPosts = dataProvider.getTourismPosts;
    final servicesPosts = dataProvider.getServicesPosts;
    final trafficsPosts = dataProvider.getTrafficPosts;

    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                        tourismPosts.isEmpty && loading == false
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No data is availble at the moment')
                                  ],
                                ),
                              )
                            : TourismView(tourismPosts: tourismPosts),
                        servicesPosts.isEmpty && loading == false
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No data is availble at the moment')
                                  ],
                                ),
                              )
                            : ServicesView(servicesPosts: servicesPosts),
                        trafficsPosts.isEmpty && loading == false
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No data is availble at the moment')
                                  ],
                                ),
                              )
                            : TrafficsView(trafficsPosts: trafficsPosts),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
