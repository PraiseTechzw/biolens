import 'package:flutter/material.dart';
import 'package:afro_dip/widgets/fly_species_card.dart';

class FlyLibraryScreen extends StatefulWidget {
  const FlyLibraryScreen({super.key});

  @override
  State<FlyLibraryScreen> createState() => _FlyLibraryScreenState();
}

class _FlyLibraryScreenState extends State<FlyLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Mock data for fly families
  final List<String> _flyFamilies = [
    'All',
    'Culicidae',
    'Muscidae',
    'Calliphoridae',
    'Sarcophagidae',
    'Tephritidae',
    'Glossinidae',
  ];
  
  String _selectedFamily = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fly Library'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search flies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Family filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _flyFamilies.length,
              itemBuilder: (context, index) {
                final family = _flyFamilies[index];
                final isSelected = family == _selectedFamily;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(family),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFamily = family;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  '24 species found',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: 'A-Z',
                  items: const [
                    DropdownMenuItem(
                      value: 'A-Z',
                      child: Text('A-Z'),
                    ),
                    DropdownMenuItem(
                      value: 'Z-A',
                      child: Text('Z-A'),
                    ),
                    DropdownMenuItem(
                      value: 'Family',
                      child: Text('Family'),
                    ),
                  ],
                  onChanged: (value) {
                    // Implement sorting
                  },
                  underline: Container(),
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
          ),
          
          // Fly species grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 10, // Mock data
              itemBuilder: (context, index) {
                // Mock fly data
                return FlySpeciesCard(
                  name: 'Fly Species ${index + 1}',
                  scientificName: 'Scientificus name',
                  family: index % 2 == 0 ? 'Culicidae' : 'Muscidae',
                  imageUrl: 'https://example.com/fly$index.jpg',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

