import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? time;
  final String? content;
  const CustomNotification({
    super.key,
    this.title,
    this.imagePath,
    this.time,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white10,
          backgroundImage: AssetImage(imagePath!),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ),
                  Text(
                    time!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                content!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
        )
      ],
    );
  }
}
