// under edits :)

// import 'package:flutter/material.dart';

// class CustomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.blueGrey,
//       shape: const CircularNotchedRectangle(),
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             // Home Button
//             MaterialButton(
//               minWidth: 40,
//               onPressed: () => onTap(0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     currentIndex == 0 ? Icons.home : Icons.home_outlined,
//                     color: currentIndex == 0 ? Colors.blue : Colors.grey,
//                   ),
//                   Text(
//                     'Home',
//                     style: TextStyle(
//                       color: currentIndex == 0 ? Colors.blue : Colors.grey,
//                     ),
                    
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(width: 40),

//             // Profile Button
//             MaterialButton(
//               minWidth: 40,
//               onPressed: () => onTap(1), 
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     currentIndex == 1 ? Icons.person : Icons.person_outline,
//                     color: currentIndex == 1 ? Colors.blue : Colors.grey,
//                   ),
//                   Text(
//                     'Profile',
//                     style: TextStyle(
//                       color: currentIndex == 1 ? Colors.blue : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }