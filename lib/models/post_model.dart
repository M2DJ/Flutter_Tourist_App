import 'package:flutter/material.dart';
import 'package:my_governate_app/main_screens/post_view.dart';
import 'package:my_governate_app/widgets/voting_row.dart';


class PostModel extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? rate;
  final int? numOfVotes;
  final String? content;

  const PostModel(
      {super.key,
      this.title,
      this.imagePath,
      this.rate,
      this.numOfVotes,
      this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 17),
      child: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Text(
                      title ?? "No title available",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PostView(
                        imagePath: imagePath ?? "assets/images/Missing-Image.png",
                        numOfVotes: numOfVotes,
                        rate: rate,
                        title: title ?? "No title available",
                        content: content ?? "No description available at the moment",
                      );
                    },
                  ));
                },
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          imagePath ?? "assets/images/Missing-Image.png",
                          fit: BoxFit.fill,
                          width: double.infinity,
                        )),
                  ),
                ),
              ),
              VotingRow(numOfVotes: numOfVotes, rate: rate),
            ],
          ),
        ),
      ),
    );
  }
}
