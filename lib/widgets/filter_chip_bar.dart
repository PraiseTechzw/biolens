import 'package:flutter/material.dart';

class FilterChipBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  
  const FilterChipBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context,
            'all',
            'All',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'verified',
            'Verified',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'high_risk',
            'High Risk',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'nearby',
            'Nearby',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            'my_reports',
            'My Reports',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String value, String label) {
    final isSelected = selectedFilter == value;
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        onFilterChanged(value);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

