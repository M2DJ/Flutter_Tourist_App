import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_governate_app/main_screens/place_detail_screen.dart';
import 'package:my_governate_app/theme/app_theme.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String _selectedFilter = 'All';
  double _minRating = 0.0;

  final List<Map<String, dynamic>> _allPlaces = [
    {
      "title": "Giza Pyramid",
      "type": "Tourism",
      "rate": 4.7,
      "imagePath": "assets/images/Pyramids.png",
    },
    {
      "title": "Balady Cafe",
      "type": "Services",
      "rate": 3.78,
      "imagePath": "assets/images/little_shop.jpeg",
    },
    {
      "title": "Ramsis Station",
      "type": "Traffic",
      "rate": 4.7,
      "imagePath": "assets/images/ramsis.png",
    },
    {
      "title": "Takeaway Restaurant",
      "type": "Services",
      "rate": 2.1,
      "imagePath": "assets/images/restaurant.png",
    },
  ];

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty && _selectedFilter == 'All' && _minRating == 0.0) {
          _searchResults = [];
        } else {
          _searchResults = _allPlaces.where((place) {
            // Text search
            bool matchesText = query.isEmpty ||
                place['title'].toLowerCase().contains(query.toLowerCase()) ||
                place['type'].toLowerCase().contains(query.toLowerCase());
            
            // Type filter
            bool matchesType = _selectedFilter == 'All' || 
                place['type'] == _selectedFilter;
            
            // Rating filter
            bool matchesRating = place['rate'] >= _minRating;
            
            return matchesText && matchesType && matchesRating;
          }).toList();
        }
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover Places",
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                "Find amazing places around you",
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingL),
              _buildSearchBar(),
              const SizedBox(height: AppTheme.spacingM),
              _buildFilters(),
              const SizedBox(height: AppTheme.spacingM),
              Expanded(
                child: _isSearching
                    ? _buildLoadingState()
                    : _searchResults.isEmpty
                        ? _buildEmptyState()
                        : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        decoration: AppTheme.inputDecoration(
          hintText: "Search for places, services...",
          prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppTheme.textMuted),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', _selectedFilter == 'All'),
          const SizedBox(width: AppTheme.spacingS),
          _buildFilterChip('Tourism', _selectedFilter == 'Tourism'),
          const SizedBox(width: AppTheme.spacingS),
          _buildFilterChip('Services', _selectedFilter == 'Services'),
          const SizedBox(width: AppTheme.spacingS),
          _buildFilterChip('Traffic', _selectedFilter == 'Traffic'),
          const SizedBox(width: AppTheme.spacingM),
          _buildRatingFilter(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? label : 'All';
          _performSearch(_searchController.text);
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(color: AppTheme.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            '${_minRating.toStringAsFixed(1)}+',
            style: GoogleFonts.inter(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showRatingDialog(),
            child: Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryColor, size: 16),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Minimum Rating', style: AppTheme.headingSmall),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _minRating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                activeColor: AppTheme.primaryColor,
                label: _minRating.toStringAsFixed(1),
                onChanged: (value) {
                  setDialogState(() {
                    _minRating = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0.0', style: AppTheme.bodySmall),
                  Text('5.0', style: AppTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _performSearch(_searchController.text);
              });
              Navigator.pop(context);
            },
            style: AppTheme.primaryButton,
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Searching...',
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchController.text.isEmpty ? Icons.explore : Icons.search_off,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            _searchController.text.isEmpty
                ? "Start Exploring"
                : "No Results Found",
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            _searchController.text.isEmpty
                ? "Search for amazing places, services, and attractions around you"
                : "Try adjusting your search or filters to find what you're looking for",
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingL),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedFilter = 'All';
                  _minRating = 0.0;
                  _searchResults = [];
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Clear Filters'),
              style: AppTheme.primaryButton,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingM),
      itemBuilder: (context, index) {
        final place = _searchResults[index];
        return _buildPlaceCard(place);
      },
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppTheme.cardRadius,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(place: place),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Hero(
                  tag: 'place_${place['title']}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        place['imagePath'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['title'],
                        style: AppTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          place['type'],
                          style: GoogleFonts.inter(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place['rate'].toString(),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Icon(
                            Icons.location_on_rounded,
                            color: AppTheme.textMuted,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Nearby',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}