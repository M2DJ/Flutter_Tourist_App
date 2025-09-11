import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  const CustomTab({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Tab(
        child: Container(
          height: 35,
          width: 114,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff3174F0), width: 1.3),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }
}
