import 'package:flutter/material.dart';

class AboutTextContainer extends StatelessWidget {
  final String? title;
  final String? text;
  
  const AboutTextContainer({
    super.key, this.title, this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(2),
        width: MediaQuery.sizeOf(context).width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: const Color(0xff5A91F7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  height: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
