import 'package:flutter/material.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:my_governate_app/widgets/custom_app_bar.dart';
import 'package:my_governate_app/widgets/voting_row.dart';
import 'package:provider/provider.dart';

class PostView extends StatelessWidget {
  final String xid;

  const PostView({super.key, required this.xid});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final post = dataProvider.getTourismPosts
        .firstWhere((p) => p['id'] == xid, orElse: () => {});

    if (post.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: const Center(
          child: Text("Post not found"),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 234,
                width: MediaQuery.sizeOf(context).width * 0.93,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: post['imagePath'] != null &&
                            post['imagePath'].toString().startsWith('http')
                        ? Image.network(
                            post['imagePath'],
                            fit: BoxFit.fill,
                            width: double.infinity,
                          )
                        : Image.asset(
                            'assets/images/Missing-Image.png',
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              VotingRow(
                  numOfVotes: post["numOfVotes"] ?? '0',
                  rate: post['rate'].toString()),
              const SizedBox(
                height: 10,
              ),
              Text(
                post['title'] ?? 'No Title',
                style: const TextStyle(fontSize: 23),
              ),
              Text(
                post['content'] ?? "Loading decription...",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.place, color: Colors.grey.shade700),
                  Text(
                    "Giza Necropolis, Al Haram, Giza Governorate,\n Greater Cairo, Egypt",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios))
            ],
          ),
        ),
      ),
    );
  }
}
