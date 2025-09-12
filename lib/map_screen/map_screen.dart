import 'package:flutter/material.dart';
import 'package:my_governate_app/map_screen/customSearchFields.dart';
import 'package:my_governate_app/widgets/custom_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final List<String> places = [
    "New Cairo",
    "6th of October",
    "Nasr City",
    "Heliopolis",
  ];

  List<String> fromSuggestions = [];
  List<String> toSuggestions = [];

  void updateFromSuggestions(String query) {
    setState(() {
      fromSuggestions = places
          .where((place) => place.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void updateToSuggestions(String query) {
    setState(() {
      toSuggestions = places
          .where((place) => place.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchField(
              label: "From",
              controller: fromController,
              hint: "Enter starting place",
              suggestions: fromSuggestions,
              onChanged: updateFromSuggestions,
              onSuggestionSelected: (value) {
                fromController.text = value;
                setState(() => fromSuggestions.clear());
              },
            ),
            const SizedBox(height: 20),
            CustomSearchField(
              label: "To",
              controller: toController,
              hint: "Enter destination place",
              suggestions: toSuggestions,
              onChanged: updateToSuggestions,
              onSuggestionSelected: (value) {
                toController.text = value;
                setState(() => toSuggestions.clear());
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
