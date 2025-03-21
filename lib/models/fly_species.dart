class FlySpecies {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final double confidenceScore;
  final String description;
  final String habitat;
  final String behavior;
  final String healthRisks;
  final String preventionTips;
  final String imageUrl;
  final String geographicDistribution;
  final int? identificationCount;
  final List<String>? relatedSpeciesIds;

  FlySpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.confidenceScore,
    required this.description,
    required this.habitat,
    required this.behavior,
    required this.healthRisks,
    required this.preventionTips,
    required this.imageUrl,
    required this.geographicDistribution,
    this.identificationCount,
    this.relatedSpeciesIds,
  });
  
  FlySpecies copyWith({
    String? id,
    String? commonName,
    String? scientificName,
    String? family,
    double? confidenceScore,
    String? description,
    String? habitat,
    String? behavior,
    String? healthRisks,
    String? preventionTips,
    String? imageUrl,
    String? geographicDistribution,
    int? identificationCount,
    List<String>? relatedSpeciesIds,
  }) {
    return FlySpecies(
      id: id ?? this.id,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      description: description ?? this.description,
      habitat: habitat ?? this.habitat,
      behavior: behavior ?? this.behavior,
      healthRisks: healthRisks ?? this.healthRisks,
      preventionTips: preventionTips ?? this.preventionTips,
      imageUrl: imageUrl ?? this.imageUrl,
      geographicDistribution: geographicDistribution ?? this.geographicDistribution,
      identificationCount: identificationCount ?? this.identificationCount,
      relatedSpeciesIds: relatedSpeciesIds ?? this.relatedSpeciesIds,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'confidenceScore': confidenceScore,
      'description': description,
      'habitat': habitat,
      'behavior': behavior,
      'healthRisks': healthRisks,
      'preventionTips': preventionTips,
      'imageUrl': imageUrl,
      'geographicDistribution': geographicDistribution,
      'identificationCount': identificationCount,
      'relatedSpeciesIds': relatedSpeciesIds,
    };
  }
  
  factory FlySpecies.fromJson(Map<String, dynamic> json) {
    return FlySpecies(
      id: json['id'],
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      family: json['family'],
      confidenceScore: json['confidenceScore'].toDouble(),
      description: json['description'],
      habitat: json['habitat'],
      behavior: json['behavior'],
      healthRisks: json['healthRisks'],
      preventionTips: json['preventionTips'],
      imageUrl: json['imageUrl'],
      geographicDistribution: json['geographicDistribution'],
      identificationCount: json['identificationCount'],
      relatedSpeciesIds: json['relatedSpeciesIds'] != null 
          ? List<String>.from(json['relatedSpeciesIds']) 
          : null,
    );
  }
}

