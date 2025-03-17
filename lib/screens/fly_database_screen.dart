import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import '../widgets/species_card.dart';

class FlyDatabaseScreen extends StatefulWidget {
  const FlyDatabaseScreen({Key? key}) : super(key: key);

  @override
  _FlyDatabaseScreenState createState() => _FlyDatabaseScreenState();
}

class _FlyDatabaseScreenState extends State<FlyDatabaseScreen> {
  bool _isGridView = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  final List<String> _filters = [
    'All',
    'Muscidae',
    'Calliphoridae',
    'Drosophilidae',
    'Syrphidae',
  ];
  
  @override
  void initState() {
    super.initState();
    // Load species data when the screen initializes
    Future.microtask(() => 
      Provider.of<SpeciesProvider>(context, listen: false).loadSpecies()
    );
  }
  
  List<dynamic> _getFilteredSpecies() {
    final speciesProvider = Provider.of<SpeciesProvider>(context);
    
    return speciesProvider.species.where((species) {
      // Apply search filter
      final nameMatch = species.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final scientificNameMatch = species.scientificName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply category filter
      final categoryMatch = _selectedFilter == 'All' || species.family == _selectedFilter;
      
      return (nameMatch || scientificNameMatch) && categoryMatch;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final speciesProvider = Provider.of<SpeciesProvider>(context);
    final filteredSpecies = _getFilteredSpecies();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fly Database'),
        actions: [
          // Toggle view button
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
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
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search flies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredSpecies.length} species found',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.sort),
                  label: const Text('Sort'),
                  onPressed: () {
                    _showSortDialog();
                  },
                ),
              ],
            ),
          ),
          
          // Species list/grid
          Expanded(
            child: speciesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredSpecies.isEmpty
                    ? const Center(
                        child: Text('No species found'),
                      )
                    : _isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filteredSpecies.length,
                            itemBuilder: (context, index) {
                              final species = filteredSpecies[index];
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
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredSpecies.length,
                            itemBuilder: (context, index) {
                              final species = filteredSpecies[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(species.imageUrl),
                                  ),
                                  title: Text(species.name),
                                  subtitle: Text(species.scientificName),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/species_details',
                                      arguments: species,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
  
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Species',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Family',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _filters.map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Habitat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  'All',
                  'Urban',
                  'Forest',
                  'Wetland',
                  'Agricultural',
                ].map((habitat) {
                  return FilterChip(
                    label: Text(habitat),
                    selected: false,
                    onSelected: (selected) {
                      // Implement habitat filtering
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'All';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Reset Filters'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Sort By'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                // Sort by name
                Navigator.pop(context);
              },
              child: const Text('Name (A-Z)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Sort by name descending
                Navigator.pop(context);
              },
              child: const Text('Name (Z-A)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Sort by family
                Navigator.pop(context);
              },
              child: const Text('Family'),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Sort by recently added
                Navigator.pop(context);
              },
              child: const Text('Recently Added'),
            ),
          ],
        );
      },
    );
  }
} 