import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> _categories = [
    'Agricultural Pests',
    'Disease Vectors',
    'Household Pests',
    'Livestock Pests',
    'Stored Product Pests',
  ];

  String _selectedCategory = 'Agricultural Pests';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          // Category selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Content area
          Expanded(
            child: _buildCategoryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case 'Agricultural Pests':
        return _buildAgriculturalPests();
      case 'Disease Vectors':
        return _buildDiseaseVectors();
      case 'Household Pests':
        return _buildHouseholdPests();
      case 'Livestock Pests':
        return _buildLivestockPests();
      case 'Stored Product Pests':
        return _buildStoredProductPests();
      default:
        return _buildAgriculturalPests();
    }
  }

  Widget _buildAgriculturalPests() {
    final pests = [
      {
        'name': 'Fall Armyworm',
        'scientificName': 'Spodoptera frugiperda',
        'description': 'A destructive pest that feeds on more than 80 plant species, causing major damage to economically important crops such as maize, rice, and sorghum.',
        'image': 'https://images.unsplash.com/photo-1567793736005-599e0fc30f21?w=800',
        'affectedCrops': 'Maize, Sorghum, Rice, Sugarcane',
        'controlMethods': 'Early planting, intercropping, natural enemies, biopesticides, selective chemical pesticides',
      },
      {
        'name': 'African Bollworm',
        'scientificName': 'Helicoverpa armigera',
        'description': 'A highly polyphagous pest that attacks cotton, tomatoes, maize, chickpea, and many other crops. The larvae feed on plant parts including leaves, flowers, and fruits.',
        'image': 'https://images.unsplash.com/photo-1575464362889-a91af6b25e89?w=800',
        'affectedCrops': 'Cotton, Tomato, Maize, Chickpea, Sunflower',
        'controlMethods': 'Crop rotation, resistant varieties, pheromone traps, biological control, targeted spraying',
      },
      {
        'name': 'Red Locust',
        'scientificName': 'Nomadacris septemfasciata',
        'description': 'A major pest in Eastern and Southern Africa that forms swarms and can devastate crops and pastures. Outbreaks can lead to significant food security issues.',
        'image': 'https://images.unsplash.com/photo-1611692475329-c1c9a9f80e7b?w=800',
        'affectedCrops': 'Grains, Vegetables, Pasture',
        'controlMethods': 'Early detection, targeted control in breeding areas, biopesticides, coordinated regional response',
      },
    ];
    
    return _buildPestList(pests);
  }

  Widget _buildDiseaseVectors() {
    final pests = [
      {
        'name': 'Anopheles Mosquito',
        'scientificName': 'Anopheles gambiae',
        'description': 'The primary vector for malaria in Africa. Female Anopheles mosquitoes can transmit Plasmodium parasites that cause malaria when they bite humans.',
        'image': 'https://images.unsplash.com/photo-1634138235740-a37a1d1e0f8a?w=800',
        'diseases': 'Malaria',
        'controlMethods': 'Insecticide-treated bed nets, indoor residual spraying, larval source management, environmental management',
      },
      {
        'name': 'Tsetse Fly',
        'scientificName': 'Glossina morsitans',
        'description': 'Tsetse flies transmit trypanosomes, which cause human sleeping sickness and animal trypanosomiasis (nagana). They are found only in tropical Africa.',
        'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=800',
        'diseases': 'Human African Trypanosomiasis (sleeping sickness), Animal Trypanosomiasis (nagana)',
        'controlMethods': 'Insecticide-treated targets and traps, sterile insect technique, bush clearing, prophylactic drugs for livestock',
      },
      {
        'name': 'Aedes Mosquito',
        'scientificName': 'Aedes aegypti',
        'description': 'A vector for several viral diseases. These mosquitoes breed in standing water and are active during the day, particularly at dawn and dusk.',
        'image': 'https://images.unsplash.com/photo-1567793736005-599e0fc30f21?w=800',
        'diseases': 'Dengue fever, Yellow fever, Chikungunya, Zika virus',
        'controlMethods': 'Source reduction (removing standing water), larvicides, personal protection, community education',
      },
    ];
    
    return _buildPestList(pests);
  }

  Widget _buildHouseholdPests() {
    final pests = [
      {
        'name': 'Bed Bug',
        'scientificName': 'Cimex lectularius',
        'description': 'Small, flat insects that feed on the blood of humans and animals while they sleep. They do not transmit diseases but can cause allergic reactions and psychological distress.',
        'image': 'https://images.unsplash.com/photo-1611692475329-c1c9a9f80e7b?w=800',
        'habitat': 'Beds, furniture, cracks in walls and floors',
        'controlMethods': 'Heat treatment, thorough cleaning, insecticides, encasing mattresses, professional extermination',
      },
      {
        'name': 'Cockroach',
        'scientificName': 'Blattella germanica',
        'description': 'Common household pests that can spread bacteria and trigger allergies and asthma. They are nocturnal and prefer warm, humid environments.',
        'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=800',
        'habitat': 'Kitchens, bathrooms, sewers, drains',
        'controlMethods': 'Sanitation, sealing entry points, baits and traps, insecticides, professional pest control',
      },
      {
        'name': 'House Fly',
        'scientificName': 'Musca domestica',
        'description': 'Common flies that can spread diseases by transferring bacteria from waste to food. They have a short life cycle and can reproduce rapidly.',
        'image': 'https://images.unsplash.com/photo-1575464362889-a91af6b25e89?w=800',
        'habitat': 'Garbage, animal waste, decaying organic matter',
        'controlMethods': 'Sanitation, screens on windows and doors, fly traps, insecticides, proper waste management',
      },
    ];
    
    return _buildPestList(pests);
  }

  Widget _buildLivestockPests() {
    final pests = [
      {
        'name': 'Cattle Tick',
        'scientificName': 'Rhipicephalus microplus',
        'description': 'External parasites that attach to cattle and other livestock to feed on blood. They can transmit diseases and cause anemia, reduced weight gain, and decreased milk production.',
        'image': 'https://images.unsplash.com/photo-1567793736005-599e0fc30f21?w=800',
        'affectedAnimals': 'Cattle, Buffalo, Sheep, Goats',
        'controlMethods': 'Acaricides, rotational grazing, resistant breeds, biological control, vaccines',
      },
      {
        'name': 'Stable Fly',
        'scientificName': 'Stomoxys calcitrans',
        'description': 'Biting flies that feed on the blood of livestock, causing stress, reduced feeding, and decreased production. They can also transmit some diseases.',
        'image': 'https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=800',
        'affectedAnimals': 'Cattle, Horses, Pigs',
        'controlMethods': 'Sanitation, biological control, traps, insecticides, proper manure management',
      },
      {
        'name': 'Sheep Ked',
        'scientificName': 'Melophagus ovinus',
        'description': 'Wingless, blood-sucking parasitic flies that live in the wool of sheep. They cause irritation, wool damage, and reduced weight gain.',
        'image': 'https://images.unsplash.com/photo-1611692475329-c1c9a9f80e7b?w=800',
        'affectedAnimals': 'Sheep',
        'controlMethods': 'Shearing, dipping, pour-on insecticides, injectable treatments',
      },
    ];
    
    return _buildPestList(pests);
  }

  Widget _buildStoredProductPests() {
    final pests = [
      {
        'name': 'Maize Weevil',
        'scientificName': 'Sitophilus zeamais',
        'description': 'A serious pest of stored maize and other grains. Adults bore into kernels to lay eggs, and larvae develop inside, causing weight loss, quality reduction, and contamination.',
        'image': 'https://images.unsplash.com/photo-1575464362889-a91af6b25e89?w=800',
        'affectedProducts': 'Maize, Rice, Wheat, Sorghum',
        'controlMethods': 'Proper drying, hermetic storage, clean stores, fumigation, botanical insecticides',
      },
      {
        'name': 'Larger Grain Borer',
        'scientificName': 'Prostephanus truncatus',
        'description': 'A destructive pest of stored maize and dried cassava. It can cause severe damage, with losses of up to 40% in untreated stored maize.',
        'image': 'https://images.unsplash.com/photo-1567793736005-599e0fc30f21?w=800',
        'affectedProducts': 'Maize, Dried Cassava',
        'controlMethods': 'Early harvesting, proper drying, hermetic storage, chemical protectants, pheromone traps',
      },
      {
        'name': 'Red Flour Beetle',
        'scientificName': 'Tribolium castaneum',
        'description': 'A common pest of flour, cereals, and other processed grain products. It contaminates food with excrement and secretions, causing off-flavors and odors.',
        'image': 'https://images.unsplash.com/photo-1634138235740-a37a1d1e0f8a?w=800',
        'affectedProducts': 'Flour, Cereals, Processed Grains, Nuts',
        'controlMethods': 'Good sanitation, temperature control, low humidity, fumigation, insect growth regulators',
      },
    ];
    
    return _buildPestList(pests);
  }

  Widget _buildPestList(List<Map<String, String>> pests) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pests.length,
      itemBuilder: (context, index) {
        final pest = pests[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  pest['image']!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pest['name']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pest['scientificName']!,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pest['description']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    
                    // Additional info
                    if (pest.containsKey('affectedCrops'))
                      _buildInfoRow('Affected Crops:', pest['affectedCrops']!),
                    if (pest.containsKey('diseases'))
                      _buildInfoRow('Diseases:', pest['diseases']!),
                    if (pest.containsKey('habitat'))
                      _buildInfoRow('Habitat:', pest['habitat']!),
                    if (pest.containsKey('affectedAnimals'))
                      _buildInfoRow('Affected Animals:', pest['affectedAnimals']!),
                    if (pest.containsKey('affectedProducts'))
                      _buildInfoRow('Affected Products:', pest['affectedProducts']!),
                    
                    const SizedBox(height: 8),
                    _buildInfoRow('Control Methods:', pest['controlMethods']!),
                    
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Navigate to detailed information
                      },
                      child: const Text('Learn More'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

