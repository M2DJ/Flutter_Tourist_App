import 'package:flutter/material.dart';
import 'package:my_governate_app/models/post_model.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({
    super.key,
    required this.servicesPosts,
    required this.onPostTap,
  });

  final List<dynamic> servicesPosts;
  final Function(double lat, double lng) onPostTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: servicesPosts.length,
      itemBuilder: (context, index) {
        final post = servicesPosts[index];
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
