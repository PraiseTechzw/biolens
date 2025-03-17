import '../models/species.dart';

class SpeciesService {
  // Simulate API calls with mock data
  Future<List<Species>> getSpecies() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return [
      Species(
        id: '1',
        name: 'House Fly',
        scientificName: 'Musca domestica',
        family: 'Muscidae',
        description: 'The house fly is a fly of the suborder Cyclorrhapha. It is the most common fly species found in houses. Adults are gray to black, with four dark, longitudinal lines on the thorax, slightly hairy bodies, and a single pair of membranous wings.',
        habitat: 'House flies are found worldwide and thrive in human habitats. They are commonly found in homes, restaurants, and areas with decaying organic matter.',
        lifeCycle: 'The house fly has a complete metamorphosis with distinct egg, larva, pupa, and adult stages. The entire life cycle from egg to adult can be completed in as little as 7 to 10 days under optimal conditions.',
        behavior: 'House flies feed on liquid or semi-liquid substances and solid materials which have been softened by their saliva. They are known to regurgitate digestive fluids to liquefy solid food before ingesting it.',
        size: '6-7 mm',
        distribution: 'Worldwide',
        conservationStatus: 'Not threatened',
        imageUrl: '/placeholder.svg?height=400&width=400',
        similarSpecies: [],
      ),
      Species(
        id: '2',
        name: 'Fruit Fly',
        scientificName: 'Drosophila melanogaster',
        family: 'Drosophilidae',
        description: 'Fruit flies are small flies that feed on fermenting fruit and other organic material. They are commonly used in genetic research due to their short life cycle and easily observable traits.',
        habitat: 'Fruit flies are found near unrefrigerated produce, fermenting liquids, and other moist organic materials.',
        lifeCycle: 'The fruit fly has a rapid life cycle, completing development from egg to adult in about 8-10 days at room temperature. The larvae feed on the microorganisms that decompose fruit, as well as the sugar of the fruit itself.',
        behavior: 'Fruit flies are attracted to ripened fruits and vegetables. They can detect food from a considerable distance and can enter homes through very small openings.',
        size: '2-3 mm',
        distribution: 'Worldwide',
        conservationStatus: 'Not threatened',
        imageUrl: '/placeholder.svg?height=400&width=400',
        similarSpecies: [],
      ),
      Species(
        id: '3',
        name: 'Blow Fly',
        scientificName: 'Calliphora vomitoria',
        family: 'Calliphoridae',
        description: 'Blow flies are medium to large flies with metallic blue or green coloration. They are often the first insects to arrive at a dead animal, making them important in forensic entomology.',
        habitat: 'Blow flies are found worldwide and are commonly associated with decaying organic matter, including carrion and excrement.',
        lifeCycle: 'Blow flies undergo complete metamorphosis with egg, larva, pupa, and adult stages. The larvae (maggots) develop rapidly in decaying organic matter and are important decomposers.',
        behavior: 'Adult blow flies feed on nectar, pollen, and other sugary substances. Females lay eggs on decaying organic matter where the larvae will have a food source.',
        size: '10-14 mm',
        distribution: 'Worldwide',
        conservationStatus: 'Not threatened',
        imageUrl: '/placeholder.svg?height=400&width=400',
        similarSpecies: [],
      ),
      Species(
        id: '4',
        name: 'Hover Fly',
        scientificName: 'Syrphus ribesii',
        family: 'Syrphidae',
        description: 'Hover flies are flies that mimic the appearance of bees or wasps. They are important pollinators and their larvae are often predators of aphids and other garden pests.',
        habitat: 'Hover flies are found in gardens, meadows, and woodlands where flowering plants are present.',
        lifeCycle: 'Hover flies undergo complete metamorphosis. The larvae of many species feed on aphids and other soft-bodied insects, making them beneficial for garden pest control.',
        behavior: 'Adult hover flies feed on nectar and pollen. They are known for their ability to hover in mid-air, similar to hummingbirds.',
        size: '7-13 mm',
        distribution: 'Worldwide',
        conservationStatus: 'Not threatened',
        imageUrl: '/placeholder.svg?height=400&width=400',
        similarSpecies: [],
      ),
    ];
  }
  
  Future<List<Species>> getPopularSpecies() async {
    // Get all species and return a subset
    final allSpecies = await getSpecies();
    return allSpecies.sublist(0, allSpecies.length > 2 ? 2 : allSpecies.length);
  }
  
  Future<Species> getSpeciesById(String id) async {
    final allSpecies = await getSpecies();
    return allSpecies.firstWhere((species) => species.id == id);
  }
}

