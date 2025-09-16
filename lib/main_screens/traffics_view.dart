import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/post_view.dart';
import 'package:my_governate_app/models/post_model.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class TrafficsView extends StatefulWidget {
  const TrafficsView({
    super.key,
    required this.trafficsPosts,
  });

  final List trafficsPosts;

  @override
  State<TrafficsView> createState() => _TrafficsViewState();
}

class _TrafficsViewState extends State<TrafficsView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final trafficsPosts = context.watch<DataProvider>().getTrafficPosts;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: trafficsPosts.length,
      itemBuilder: (context, index) {
        final post = trafficsPosts[index];
        return InkWell(
          onTap: () {
            setState(() {
              loading = true;
            });
            context.read<DataProvider>().loadTourismInfo(post['id']);

            print('This is supposed to get data');

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => loading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          ),
                        )
                      : PostView(xid: post['id'])),
            );

            setState(() {
              loading = false;
            });
          },
          child: PostModel(
            title: post["title"],
            imagePath: post["imagePath"],
            numOfVotes: post["numOfVotes"],
            rate: post["rate"],
            content: post["content"],
          ),
        );
      },
    );
  }
}
