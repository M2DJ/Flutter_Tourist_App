import 'package:flutter/material.dart';

class VotingRow extends StatelessWidget {
  final int? numOfVotes;
  final double? rate;
  const VotingRow({
    super.key,
    required this.numOfVotes,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 27,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 2,
            child: CircleAvatar(
              radius: 13,
              backgroundImage: AssetImage("assets/images/profile1.png"),
            ),
          ),
          const Positioned(
            left: 16,
            child: CircleAvatar(
              radius: 13,
              backgroundImage: AssetImage("assets/images/profile2.png"),
            ),
          ),
          const Positioned(
            left: 32,
            child: CircleAvatar(
              radius: 13,
              backgroundImage: AssetImage("assets/images/profile3.png"),
            ),
          ),
          Positioned(
            left: 51,
            child: CircleAvatar(
              radius: 13,
              child: Text(
                "+${numOfVotes!}",
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          Positioned(
            right: 25,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 23,
                    ),
                    Text(rate!.toStringAsFixed(1)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
