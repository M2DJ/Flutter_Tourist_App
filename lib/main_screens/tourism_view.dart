import 'package:flutter/material.dart';
import 'package:my_governate_app/models/post_model.dart';

class TourismView extends StatelessWidget {
  const TourismView({
    super.key,
    required this.tourismPosts,
  });

  final List tourismPosts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tourismPosts.length,
      itemBuilder: (context, index) {
        final post = tourismPosts[index];
        return PostModel(
          title: post["title"] ?? "No title available",
          imagePath: post["imagePath"] ?? "assets/images/Missing-Image.png",
          numOfVotes: post["numOfVotes"] ?? 0,
          rate: post["rate"] ?? "0",
          content: post["content"] ?? "No description available at the moment",
        );
      },
    );
  }
}
