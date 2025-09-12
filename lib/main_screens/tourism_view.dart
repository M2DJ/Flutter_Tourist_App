import 'package:flutter/material.dart';
import 'package:my_governate_app/models/post_model.dart';

class TourismView extends StatelessWidget {
  const TourismView({
    super.key,
    required this.tourismPosts,
    // required this.onPostTap,
  });

  final List<dynamic> tourismPosts;
  // final Function(String) onPostTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tourismPosts.length,
      itemBuilder: (context, index) {
        final post = tourismPosts[index];
        return PostModel(
          title: post["title"] ?? '',
          imagePath: post["imagePath"] ?? '',
          numOfVotes: post["numOfVotes"] ?? '',
          rate: post["rate"] ?? '',
          content: post["content"] ?? '',
          // onPostTap: () => onPostTap(index, p),
        );
      },
    );
  }
}
