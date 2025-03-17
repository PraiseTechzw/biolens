class Species {
  final String id;
  final String name;
  final String scientificName;
  final String family;
  final String description;
  final String habitat;
  final String lifeCycle;
  final String behavior;
  final String size;
  final String distribution;
  final String conservationStatus;
  final String imageUrl;
  final List<Species> similarSpecies;
  
  Species({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.family,
    required this.description,
    required this.habitat,
    required this.lifeCycle,
    required this.behavior,
    required this.size,
    required this.distribution,
    required this.conservationStatus,
    required this.imageUrl,
    this.similarSpecies = const [],
  });
  
  factory Species.fromJson(Map<String, dynamic> json) {
    List<Species> similarSpecies = [];
    
    if (json['similarSpecies'] != null) {
      similarSpecies = (json['similarSpecies'] as List)
          .map((item) => Species.fromJson(item))
          .toList();
    }
    
    return Species(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      family: json['family'],
      description: json['description'],
      habitat: json['habitat'],
      lifeCycle: json['lifeCycle'],
      behavior: json['behavior'],
      size: json['size'],
      distribution: json['distribution'],
      conservationStatus: json['conservationStatus'],
      imageUrl: json['imageUrl'],
      similarSpecies: similarSpecies,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'family': family,
      'description': description,
      'habitat': habitat,
      'lifeCycle': lifeCycle,
      'behavior': behavior,
      'size': size,
      'distribution': distribution,
      'conservationStatus': conservationStatus,
      'imageUrl': imageUrl,
      'similarSpecies': similarSpecies.map((species) => species.toJson()).toList(),
    };
  }
}

class Identification {
  final Species species;
  final double confidence;
  final String dateTime;
  final String imageUrl;
  
  Identification({
    required this.species,
    required this.confidence,
    required this.dateTime,
    required this.imageUrl,
  });
}

