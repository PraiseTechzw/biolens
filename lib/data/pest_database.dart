import '../models/pest.dart';

class PestDatabase {
  static Pest getTsetseFly() {
    return Pest(
      id: 'tsetse_fly',
      name: 'Tsetse Fly',
      localName: 'Mhesvi',
      scientificName: 'Glossina morsitans',
      description: 'Tsetse flies are large biting flies that feed on the blood of animals and humans. They are found only in tropical Africa and are the primary carriers of trypanosomes, which cause human sleeping sickness and animal trypanosomiasis.',
      riskLevel: RiskLevel.high,
      actions: [
        PestAction(
          title: 'Avoid Dawn/Dusk Activity',
          description: 'Tsetse flies are most active during daylight hours, especially in early morning and late afternoon.',
          iconName: 'access_time',
        ),
        PestAction(
          title: 'Use Insecticide-Treated Nets',
          description: 'Sleep under insecticide-treated nets to prevent bites during rest.',
          iconName: 'bed',
        ),
        PestAction(
          title: 'Wear Protective Clothing',
          description: 'Wear long-sleeved shirts and pants in neutral colors. Tsetse flies are attracted to bright and dark colors.',
          iconName: 'checkroom',
        ),
      ],
      imageUrl: 'assets/images/tsetse_fly.jpg',
    );
  }
  
  static Pest getFallArmyworm() {
    return Pest(
      id: 'fall_armyworm',
      name: 'Fall Armyworm',
      localName: 'Mbundu',
      scientificName: 'Spodoptera frugiperda',
      description: 'The fall armyworm is a species of moth and a member of the Lepidoptera family. It is a dangerous crop pest and feeds on more than 80 plant species, causing major damage to economically important cultivated grasses such as maize, rice, and sorghum.',
      riskLevel: RiskLevel.high,
      actions: [
        PestAction(
          title: 'Apply Lepidocide',
          description: 'Apply Lepidocide spray every 7 days to control larvae. Available at local agro-shops.',
          iconName: 'sanitizer',
        ),
        PestAction(
          title: 'Manual Removal',
          description: 'For small farms, manually crush egg masses and larvae when detected.',
          iconName: 'back_hand',
        ),
        PestAction(
          title: 'Plant Early',
          description: 'Plant early in the season to avoid peak infestation periods.',
          iconName: 'calendar_today',
        ),
      ],
      imageUrl: 'assets/images/armyworm.jpg',
    );
  }
  
  static Pest getMalarialMosquito() {
    return Pest(
      id: 'anopheles_mosquito',
      name: 'Anopheles Mosquito',
      localName: 'Uhuvi',
      scientificName: 'Anopheles gambiae',
      description: 'Anopheles mosquitoes are the primary vectors of malaria in Africa. They typically bite between dusk and dawn, and their larvae develop in water habitats. Female Anopheles mosquitoes can transmit Plasmodium parasites that cause malaria.',
      riskLevel: RiskLevel.high,
      actions: [
        PestAction(
          title: 'Use Bed Nets',
          description: 'Sleep under insecticide-treated bed nets every night.',
          iconName: 'bed',
        ),
        PestAction(
          title: 'Remove Standing Water',
          description: 'Eliminate standing water around homes where mosquitoes breed.',
          iconName: 'water_drop',
        ),
        PestAction(
          title: 'Apply Repellent',
          description: 'Use mosquito repellent containing DEET on exposed skin.',
          iconName: 'air',
        ),
      ],
      imageUrl: 'assets/images/anopheles_mosquito.jpg',
    );
  }
  
  // Add more pest data as needed
}

