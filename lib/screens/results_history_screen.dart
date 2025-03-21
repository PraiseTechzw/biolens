import 'package:flutter/material.dart';
import 'package:afro_dip/widgets/history_item.dart';

class ResultsHistoryScreen extends StatefulWidget {
  const ResultsHistoryScreen({super.key});

  @override
  State<ResultsHistoryScreen> createState() => _ResultsHistoryScreenState();
}

class _ResultsHistoryScreenState extends State<ResultsHistoryScreen> {
  String _selectedFilter = 'All Time';
  final List<String> _filterOptions = [
    'All Time',
    'This Week',
    'This Month',
    'This Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Showing: $_selectedFilter',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Clear History'),
                  onPressed: () {
                    _showClearHistoryDialog();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15, // Mock data
              itemBuilder: (context, index) {
                // Generate a random date within the last month
                final now = DateTime.now();
                final randomDaysAgo = index * 2; // Every 2 days
                final date = now.subtract(Duration(days: randomDaysAgo));
                
                return HistoryItem(
                  flyName: 'Identified Fly ${index + 1}',
                  scientificName: 'Scientificus name',
                  confidenceScore: 0.85 + (index * 0.01),
                  date: date,
                  imageUrl: 'https://example.com/fly$index.jpg',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter History'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filterOptions.map((filter) {
              return RadioListTile<String>(
                title: Text(filter),
                value: filter,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text(
            'Are you sure you want to clear your identification history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear history logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('History cleared')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}

