import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/post_view.dart';
import 'package:my_governate_app/models/post_model.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class TourismView extends StatefulWidget {
  const TourismView({
    super.key,
    required this.tourismPosts,
  });

  final List tourismPosts;

  @override
  State<TourismView> createState() => _TourismViewState();
}

class _TourismViewState extends State<TourismView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final tourismPosts = context.watch<DataProvider>().getTourismPosts;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tourismPosts.length,
      itemBuilder: (context, index) {
        final post = tourismPosts[index];
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
                    : 
                    PostView(
                        imagePath: post["imagePath"],
                        numOfVotes: post["numOfVotes"],
                        rate: post["rate"],
                        title: post["title"],
                        content: post["content"],
                      ),
                    // PostView(xid: post['id'])
              ),
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
