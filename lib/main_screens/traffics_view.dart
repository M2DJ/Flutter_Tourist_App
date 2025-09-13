import 'package:flutter/material.dart';
import 'package:my_governate_app/models/post_model.dart';

class TrafficsView extends StatelessWidget {
  const TrafficsView({
    super.key,
    required this.trafficsPosts,
    required this.onPostTap,
  });

  final List<dynamic> trafficsPosts;
  final Function(double lat, double lng) onPostTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: trafficsPosts.length,
      itemBuilder: (context, index) {
        final post = trafficsPosts[index];
        return GestureDetector(
          onTap: () => onPostTap(post["lat"], post["lng"]),
          child: PostModel(
            title: post["title"] ?? '',
            imagePath: post["imagePath"] ?? '',
            numOfVotes: post["numOfVotes"] ?? '',
            rate: post["rate"] ?? '',
            content: post["content"] ?? '',
          ),
        );
      },
    );
  }
}
