import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useLocalSearchParams, useRouter } from 'expo-router';

interface SpeciesData {
  name: string;
  scientificName: string;
  imageUri: string;
  description: string;
  habitat: string;
  diet: string;
  behavior: string;
  conservation: {
    status: string;
    threats: string[];
    actions: string[];
  };
  funFacts: string[];
  sightings: {
    total: number;
    recent: number;
    nearbyLocations: string[];
  };
}

export default function SpeciesDetailsScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ species: string; imageUri: string }>();
  const [activeTab, setActiveTab] = useState<'overview' | 'habitat' | 'behavior' | 'conservation'>('overview');

  // Mock data - in a real app, this would come from an API based on the species parameter
  const speciesData: SpeciesData = {
    name: params.species || 'Red-tailed Hawk',
    scientificName: 'Buteo jamaicensis',
    imageUri: params.imageUri || 'https://example.com/hawk.jpg',
    description: 'The Red-tailed Hawk is one of North America\'s most common and widespread hawks. Known for its brick-red tail, this species is often seen soaring over open fields or perched on poles and fence posts.',
    habitat: 'Red-tailed Hawks can be found in various habitats across North America, from deserts to tropical rainforests. They prefer open areas with high perches for hunting, including woodlands, grasslands, mountains, plains, and roadsides.',
    diet: 'Small mammals (mice, rabbits), birds, reptiles',
    behavior: 'Red-tailed Hawks are skilled hunters that use their keen eyesight to spot prey from high perches or while soaring. They are monogamous and often mate for life, performing spectacular aerial courtship displays. These hawks are territorial and will defend their nesting areas against other raptors.',
    conservation: {
      status: 'Least Concern',
      threats: [
        'Habitat loss due to urban development',
        'Vehicle collisions',
        'Pesticide exposure',
      ],
      actions: [
        'Habitat protection and restoration',
        'Monitoring of populations',
        'Public education about raptor conservation',
      ],
    },
    funFacts: [
      'Can spot a mouse from 100 feet in the air',
      'Mated pairs often hunt together',
      'Can live up to 20 years in the wild',
    ],
    sightings: {
      total: 1247,
      recent: 15,
      nearbyLocations: [
        'Central Park',
        'Prospect Park',
        'Van Cortlandt Park',
      ],
    },
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <View>
            <Text style={styles.sectionTitle}>Description</Text>
            <Text style={styles.description}>{speciesData.description}</Text>
            
            <Text style={styles.sectionTitle}>Diet</Text>
            <Text style={styles.description}>{speciesData.diet}</Text>

            <Text style={styles.sectionTitle}>Fun Facts</Text>
            {speciesData.funFacts.map((fact, index) => (
              <View key={index} style={styles.factItem}>
                <MaterialCommunityIcons name="star" size={20} color="#FFD700" />
                <Text style={styles.factText}>{fact}</Text>
              </View>
            ))}
          </View>
        );
      
      case 'habitat':
        return (
          <View>
            <Text style={styles.sectionTitle}>Natural Habitat</Text>
            <Text style={styles.description}>{speciesData.habitat}</Text>

            <Text style={styles.sectionTitle}>Recent Sightings</Text>
            <View style={styles.sightingsStats}>
              <View style={styles.statBox}>
                <Text style={styles.statNumber}>{speciesData.sightings.total}</Text>
                <Text style={styles.statLabel}>Total Sightings</Text>
              </View>
              <View style={styles.statBox}>
                <Text style={styles.statNumber}>{speciesData.sightings.recent}</Text>
                <Text style={styles.statLabel}>This Month</Text>
              </View>
            </View>

            <Text style={styles.sectionTitle}>Nearby Locations</Text>
            {speciesData.sightings.nearbyLocations.map((location, index) => (
              <View key={index} style={styles.locationItem}>
                <Ionicons name="location" size={20} color="#2196F3" />
                <Text style={styles.locationText}>{location}</Text>
              </View>
            ))}
          </View>
        );
      
      case 'behavior':
        return (
          <View>
            <Text style={styles.sectionTitle}>Behavior Patterns</Text>
            <Text style={styles.description}>{speciesData.behavior}</Text>
          </View>
        );
      
      case 'conservation':
        return (
          <View>
            <View style={styles.statusContainer}>
              <Text style={styles.statusLabel}>Conservation Status</Text>
              <View style={[styles.statusBadge, { backgroundColor: '#4CAF50' }]}>
                <Text style={styles.statusText}>{speciesData.conservation.status}</Text>
              </View>
            </View>

            <Text style={styles.sectionTitle}>Threats</Text>
            {speciesData.conservation.threats.map((threat, index) => (
              <View key={index} style={styles.listItem}>
                <MaterialCommunityIcons name="alert" size={20} color="#FF5252" />
                <Text style={styles.listText}>{threat}</Text>
              </View>
            ))}

            <Text style={styles.sectionTitle}>Conservation Actions</Text>
            {speciesData.conservation.actions.map((action, index) => (
              <View key={index} style={styles.listItem}>
                <MaterialCommunityIcons name="shield-check" size={20} color="#4CAF50" />
                <Text style={styles.listText}>{action}</Text>
              </View>
            ))}
          </View>
        );
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000" />
        </TouchableOpacity>
        <TouchableOpacity style={styles.shareButton}>
          <Ionicons name="share-outline" size={24} color="#000" />
        </TouchableOpacity>
      </View>

      <ScrollView>
        <Image source={{ uri: speciesData.imageUri }} style={styles.image} />
        
        <View style={styles.infoContainer}>
          <View style={styles.titleContainer}>
            <View>
              <Text style={styles.speciesName}>{speciesData.name}</Text>
              <Text style={styles.scientificName}>{speciesData.scientificName}</Text>
            </View>
            <TouchableOpacity style={styles.favoriteButton}>
              <Ionicons name="heart-outline" size={24} color="#FF4081" />
            </TouchableOpacity>
          </View>

          <View style={styles.tabs}>
            {(['overview', 'habitat', 'behavior', 'conservation'] as const).map((tab) => (
              <TouchableOpacity
                key={tab}
                style={[styles.tab, activeTab === tab && styles.activeTab]}
                onPress={() => setActiveTab(tab)}
              >
                <Text style={[styles.tabText, activeTab === tab && styles.activeTabText]}>
                  {tab.charAt(0).toUpperCase() + tab.slice(1)}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <View style={styles.content}>
            {renderTabContent()}
          </View>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity
          style={styles.arButton}
          onPress={() => router.push('/(tabs)/ar-view')}
        >
          <MaterialCommunityIcons name="augmented-reality" size={24} color="#fff" />
          <Text style={styles.arButtonText}>View in AR</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    paddingTop: 60,
  },
  backButton: {
    padding: 8,
  },
  shareButton: {
    padding: 8,
  },
  image: {
    width: '100%',
    height: 300,
  },
  infoContainer: {
    flex: 1,
    padding: 20,
  },
  titleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  speciesName: {
    fontSize: 28,
    fontWeight: 'bold',
  },
  scientificName: {
    fontSize: 16,
    color: '#666',
    fontStyle: 'italic',
  },
  favoriteButton: {
    padding: 8,
  },
  tabs: {
    flexDirection: 'row',
    marginBottom: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  tab: {
    flex: 1,
    paddingVertical: 10,
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: '#2196F3',
  },
  tabText: {
    fontSize: 14,
    color: '#666',
  },
  activeTabText: {
    color: '#2196F3',
    fontWeight: 'bold',
  },
  content: {
    flex: 1,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginTop: 20,
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    color: '#333',
    lineHeight: 24,
  },
  factItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  factText: {
    fontSize: 16,
    marginLeft: 10,
    flex: 1,
  },
  sightingsStats: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginVertical: 20,
  },
  statBox: {
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    minWidth: 120,
  },
  statNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#2196F3',
  },
  statLabel: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  locationItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  locationText: {
    fontSize: 16,
    marginLeft: 10,
  },
  statusContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginVertical: 10,
  },
  statusLabel: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  statusBadge: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 15,
  },
  statusText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
  },
  listItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  listText: {
    fontSize: 16,
    marginLeft: 10,
    flex: 1,
  },
  footer: {
    padding: 20,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  arButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#2196F3',
    padding: 15,
    borderRadius: 10,
  },
  arButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 10,
  },
}); 