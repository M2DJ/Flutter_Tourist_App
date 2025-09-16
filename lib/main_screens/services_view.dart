import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/post_view.dart';
import 'package:my_governate_app/models/post_model.dart';
import 'package:my_governate_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key, required this.servicesPosts});

  final List servicesPosts;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final servicesPosts = context.watch<DataProvider>().getServicesPosts;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: servicesPosts.length,
      itemBuilder: (context, index) {
        final post = servicesPosts[index];
        return InkWell(
          onTap: () {
            setState(() {
              loading = true;
            });
            context.read<DataProvider>().loadServicesInfo(post['id']);

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
                    PostView(xid: post['id'])
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
