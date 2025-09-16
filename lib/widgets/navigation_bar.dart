import 'package:flutter/material.dart';
import 'package:my_governate_app/widgets/custom_nav_painter.dart';
import 'package:my_governate_app/widgets/nav_item.dart';

class CustomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 80,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.sizeOf(context).width, 80),
            painter: BNBCustomPainter(),
          ),
          Center(
            heightFactor: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavItem(
                  icon: Icons.home,
                  label: "Home",
                  isSelected: widget.selectedIndex == 0,
                  onTap: () => widget.onItemTapped(0),
                ),
                
                GestureDetector(
                  onTap: () => widget.onItemTapped(1),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xff0D6EFD),
                    child: Image.asset("assets/icons/search icon.png", scale: 1.6),
                  ),
                ),
                NavItem(
                  icon: Icons.person_outline,
                  label: "Profile",
                  isSelected: widget.selectedIndex == 2,
                  onTap: () => widget.onItemTapped(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
