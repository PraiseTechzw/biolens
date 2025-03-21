import 'package:afro_dip/models/fly_species.dart';

class IdentificationResult {
  final String id;
  final FlySpecies species;
  final double confidenceScore;
  final DateTime date;
  final String imageFilePath;
  final String? location;

  IdentificationResult({
    required this.id,
    required this.species,
    required this.confidenceScore,
    required this.date,
    required this.imageFilePath,
    this.location,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species.toJson(),
      'confidenceScore': confidenceScore,
      'date': date.toIso8601String(),
      'imageFilePath': imageFilePath,
      'location': location,
    };
  }
  
  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    return IdentificationResult(
      id: json['id'],
      species: FlySpecies.fromJson(json['species']),
      confidenceScore: json['confidenceScore'].toDouble(),
      date: DateTime.parse(json['date']),
      imageFilePath: json['imageFilePath'],
      location: json['location'],
    );
  }
}

