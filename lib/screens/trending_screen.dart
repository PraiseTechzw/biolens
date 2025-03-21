import 'package:flutter/material.dart';
import 'package:afro_dip/widgets/trending_fly_card.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trending'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'This Week'),
              Tab(text: 'Your Region'),
              Tab(text: 'Rare Finds'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTrendingList(context, 'This Week'),
            _buildTrendingList(context, 'Your Region'),
            _buildTrendingList(context, 'Rare Finds'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingList(BuildContext context, String category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TrendingFlyCard(
            rank: index + 1,
            name: 'Trending Fly ${index + 1}',
            scientificName: 'Scientificus name',
            identificationCount: 100 - (index * 10),
            imageUrl: 'https://example.com/fly$index.jpg',
            category: category,
          ),
        );
      },
    );
  }
}

