import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import '../widgets/species_card.dart';
import '../widgets/recent_identification_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load species data when the screen initializes
    Future.microtask(() => 
      Provider.of<SpeciesProvider>(context, listen: false).loadSpecies()
    );
  }

  @override
  Widget build(BuildContext context) {
    final speciesProvider = Provider.of<SpeciesProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('BioLens'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
              showSearch(
                context: context,
                delegate: SpeciesSearchDelegate(speciesProvider.species),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about_help');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.bug_report,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'BioLens',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    'Fly Identification App',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Identify'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/camera');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Fly Database'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/fly_database');
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map Tracking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/map_tracking');
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Community'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/community');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Show settings dialog or navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about_help');
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => speciesProvider.loadSpecies(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick identify button
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/camera');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Identify a Fly',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Take a photo or upload from gallery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Recent identifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Identifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: speciesProvider.recentIdentifications.isEmpty
                      ? const Center(
                          child: Text('No recent identifications'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: speciesProvider.recentIdentifications.length,
                          itemBuilder: (context, index) {
                            final identification = speciesProvider.recentIdentifications[index];
                            return RecentIdentificationCard(
                              identification: identification,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/species_details',
                                  arguments: identification.species,
                                );
                              },
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 24),
                
                // Explore section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/fly_database');
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildExploreCard(
                        icon: Icons.search,
                        title: 'Fly Database',
                        description: 'Browse all species',
                        onTap: () {
                          Navigator.pushNamed(context, '/fly_database');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildExploreCard(
                        icon: Icons.map,
                        title: 'Map Tracking',
                        description: 'View fly sightings',
                        onTap: () {
                          Navigator.pushNamed(context, '/map_tracking');
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Popular species
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Species',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/fly_database');
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                speciesProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: speciesProvider.popularSpecies.length,
                        itemBuilder: (context, index) {
                          final species = speciesProvider.popularSpecies[index];
                          return SpeciesCard(
                            species: species,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/species_details',
                                arguments: species,
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildExploreCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeciesSearchDelegate extends SearchDelegate {
  final List<dynamic> species;
  
  SpeciesSearchDelegate(this.species);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = species.where((s) => 
      s.name.toLowerCase().contains(query.toLowerCase()) ||
      s.scientificName.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final species = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(species.imageUrl),
          ),
          title: Text(species.name),
          subtitle: Text(species.scientificName),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/species_details',
              arguments: species,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : species.where((s) => 
            s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.scientificName.toLowerCase().contains(query.toLowerCase())
          ).toList();
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final species = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(species.imageUrl),
          ),
          title: Text(species.name),
          subtitle: Text(species.scientificName),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/species_details',
              arguments: species,
            );
          },
        );
      },
    );
  }
}

