import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Search bar widget
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search locations...',
          hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location, color: Color(0xFF3174F0)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location feature coming soon!')),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet with nearby places
class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Places',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF3174F0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: samplePlaces.length,
                  itemBuilder: (context, index) {
                    final place = samplePlaces[index];
                    return buildPlaceCard(context, place);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Build map markers
List<Widget> buildSampleMarkers() {
  return [
    const Positioned(
      top: 200,
      left: 100,
      child: MapMarker(title: 'Giza Pyramid', icon: Icons.camera_alt),
    ),
    const Positioned(
      top: 300,
      right: 80,
      child: MapMarker(title: 'Balady Cafe', icon: Icons.local_cafe),
    ),
    const Positioned(
      bottom: 400,
      left: 150,
      child: MapMarker(title: 'Ramsis Station', icon: Icons.train),
    ),
  ];
}

/// Marker widget
class MapMarker extends StatelessWidget {
  final String title;
  final IconData icon;

  const MapMarker({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF3174F0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Place card widget
Widget buildPlaceCard(BuildContext context, Map<String, dynamic> place) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            place['imagePath'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place['title'],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                place['type'],
                style: GoogleFonts.inter(
                  color: const Color(0xFF3174F0),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    place['rate'].toString(),
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${place['distance']} km',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.directions, color: Color(0xFF3174F0)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Directions to ${place['title']}')),
            );
          },
        ),
      ],
    ),
  );
}

/// Sample data
final List<Map<String, dynamic>> samplePlaces = [
  {
    "title": "Giza Pyramid",
    "type": "Tourism",
    "rate": 4.7,
    "distance": 2.3,
    "imagePath": "assets/images/Pyramids.png",
  },
  {
    "title": "Balady Cafe",
    "type": "Services",
    "rate": 3.78,
    "distance": 0.8,
    "imagePath": "assets/images/little_shop.jpeg",
  },
  {
    "title": "Ramsis Station",
    "type": "Traffic",
    "rate": 4.7,
    "distance": 1.5,
    "imagePath": "assets/images/ramsis.png",
  },
];
