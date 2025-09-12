import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<String> suggestions;
  final Function(String) onChanged;
  final Function(String) onSuggestionSelected;

  const CustomSearchField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.suggestions,
    required this.onChanged,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " $label",
          style: const TextStyle(
            color: Color(0xff3174F0),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(23)),
              ),
              suffixIcon: const Icon(Icons.location_on),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey)
            ),
            onChanged: onChanged,
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            height: 150,
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () => onSuggestionSelected(suggestions[index]),
                );
              },
            ),
          ),
      ],
    );
  }
}
