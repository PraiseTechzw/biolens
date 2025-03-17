enum RiskLevel {
  low,
  medium,
  high,
}

class PestAction {
  final String title;
  final String description;
  final String iconName;
  
  PestAction({
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class Pest {
  final String id;
  final String name;
  final String localName;
  final String scientificName;
  final String description;
  final RiskLevel riskLevel;
  final List<PestAction> actions;
  final String imageUrl;
  
  Pest({
    required this.id,
    required this.name,
    required this.localName,
    required this.scientificName,
    required this.description,
    required this.riskLevel,
    required this.actions,
    required this.imageUrl,
  });
  
  factory Pest.fromJson(Map<String, dynamic> json) {
    return Pest(
      id: json['id'],
      name: json['name'],
      localName: json['localName'],
      scientificName: json['scientificName'],
      description: json['description'],
      riskLevel: RiskLevel.values.byName(json['riskLevel']),
      actions: (json['actions'] as List)
          .map((action) => PestAction(
                title: action['title'],
                description: action['description'],
                iconName: action['iconName'],
              ))
          .toList(),
      imageUrl: json['imageUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localName': localName,
      'scientificName': scientificName,
      'description': description,
      'riskLevel': riskLevel.name,
      'actions': actions
          .map((action) => {
                'title': action.title,
                'description': action.description,
                'iconName': action.iconName,
              })
          .toList(),
      'imageUrl': imageUrl,
    };
  }
}

