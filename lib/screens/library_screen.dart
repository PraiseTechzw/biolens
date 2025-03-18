import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Species Library'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _flySpecies.length,
        itemBuilder: (context, index) {
          final species = _flySpecies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: Image.asset(
                species.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                species.commonName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(species.scientificName),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family: ${species.family}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Habitat: ${species.habitat}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Diseases: ${species.diseases}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Importance: ${species.importance}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Open external research source
                        },
                        icon: const Icon(Icons.link),
                        label: const Text('View Research'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FlySpecies {
  final String commonName;
  final String scientificName;
  final String family;
  final String habitat;
  final String diseases;
  final String importance;
  final String imagePath;

  const FlySpecies({
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.habitat,
    required this.diseases,
    required this.importance,
    required this.imagePath,
  });
}

final List<FlySpecies> _flySpecies = [
  const FlySpecies(
    commonName: 'Tsetse Fly',
    scientificName: 'Glossina spp.',
    family: 'Glossinidae',
    habitat: 'Tropical Africa, savanna and forest regions',
    diseases: 'African trypanosomiasis (sleeping sickness)',
    importance: 'Major vector of human and animal trypanosomiasis',
    imagePath: 'assets/images/tsetse_fly.jpg',
  ),
  const FlySpecies(
    commonName: 'House Fly',
    scientificName: 'Musca domestica',
    family: 'Muscidae',
    habitat: 'Worldwide, especially in human settlements',
    diseases: 'Typhoid, cholera, dysentery, and other gastrointestinal diseases',
    importance: 'Common disease vector and nuisance pest',
    imagePath: 'assets/images/house_fly.jpg',
  ),
  // Add more species as needed
]; 