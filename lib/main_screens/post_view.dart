import 'package:flutter/material.dart';
import 'package:my_governate_app/widgets/custom_app_bar.dart';
import 'package:my_governate_app/widgets/voting_row.dart';

class PostView extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? content;
  final double? rate;
  final int? numOfVotes;
  const PostView(
      {super.key,
      this.imagePath,
      this.content,
      this.rate,
      this.numOfVotes,
      this.title,
      });

  @override
  Widget build(BuildContext context) {
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
                      child: Image.network(
                        imagePath!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      )),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              VotingRow(numOfVotes: numOfVotes!, rate: rate!),
              const SizedBox(
                height: 10,
              ),
              Text(
                title!,
                style: const TextStyle(fontSize: 23),
              ),
              Text(
                content!,
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
