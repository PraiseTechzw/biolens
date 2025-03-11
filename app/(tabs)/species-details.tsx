import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter, useLocalSearchParams } from 'expo-router';

interface SearchParams {
  species?: string;
  imageUri?: string;
}

type TabType = 'overview' | 'habitat' | 'behavior' | 'conservation';

export default function SpeciesDetailsScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<SearchParams>();
  const [activeTab, setActiveTab] = useState<TabType>('overview');

  const speciesData = {
    name: params.species || 'Red-tailed Hawk',
    scientificName: 'Buteo jamaicensis',
    image: params.imageUri || 'https://example.com/hawk.jpg',
    overview: {
      description: 'The Red-tailed Hawk is one of the most common and widespread hawks in North America. Known for its distinctive red tail feathers, this raptor is a master of soaring flight and can often be seen perched on telephone poles or circling high in the sky.',
      size: 'Length: 45-65 cm\nWingspan: 110-145 cm\nWeight: 690-1460 g',
      lifespan: '10-15 years in the wild',
    },
    habitat: {
      regions: ['North America', 'Central America', 'Caribbean'],
      preferred: 'Open areas with scattered trees, woodlands, grasslands, and deserts',
      nesting: 'High in trees, often in the crotch of a large tree',
    },
    behavior: {
      hunting: 'Hunts from perches or while soaring, primarily for small mammals',
      social: 'Generally solitary, pairs during breeding season',
      migration: 'Northern populations migrate south in winter',
    },
    conservation: {
      status: 'Least Concern',
      threats: ['Habitat loss', 'Pesticide exposure', 'Collision with vehicles'],
      efforts: 'Protected under the Migratory Bird Treaty Act',
    },
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <View style={styles.tabContent}>
            <Text style={styles.description}>{speciesData.overview.description}</Text>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Size</Text>
              <Text style={styles.infoText}>{speciesData.overview.size}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Lifespan</Text>
              <Text style={styles.infoText}>{speciesData.overview.lifespan}</Text>
            </View>
          </View>
        );
      case 'habitat':
        return (
          <View style={styles.tabContent}>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Geographic Range</Text>
              <Text style={styles.infoText}>{speciesData.habitat.regions.join(', ')}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Preferred Habitat</Text>
              <Text style={styles.infoText}>{speciesData.habitat.preferred}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Nesting</Text>
              <Text style={styles.infoText}>{speciesData.habitat.nesting}</Text>
            </View>
          </View>
        );
      case 'behavior':
        return (
          <View style={styles.tabContent}>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Hunting</Text>
              <Text style={styles.infoText}>{speciesData.behavior.hunting}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Social Behavior</Text>
              <Text style={styles.infoText}>{speciesData.behavior.social}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Migration</Text>
              <Text style={styles.infoText}>{speciesData.behavior.migration}</Text>
            </View>
          </View>
        );
      case 'conservation':
        return (
          <View style={styles.tabContent}>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Conservation Status</Text>
              <Text style={styles.infoText}>{speciesData.conservation.status}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Threats</Text>
              <Text style={styles.infoText}>{speciesData.conservation.threats.join('\n')}</Text>
            </View>
            <View style={styles.infoCard}>
              <Text style={styles.infoTitle}>Conservation Efforts</Text>
              <Text style={styles.infoText}>{speciesData.conservation.efforts}</Text>
            </View>
          </View>
        );
      default:
        return null;
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Species Details</Text>
      </View>

      <View style={styles.imageContainer}>
        <Image
          source={{ uri: speciesData.image }}
          style={styles.speciesImage}
          resizeMode="cover"
        />
      </View>

      <View style={styles.titleContainer}>
        <Text style={styles.speciesName}>{speciesData.name}</Text>
        <Text style={styles.scientificName}>{speciesData.scientificName}</Text>
      </View>

      <View style={styles.tabs}>
        {(['overview', 'habitat', 'behavior', 'conservation'] as TabType[]).map((tab) => (
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

      <ScrollView style={styles.content}>
        {renderTabContent()}
      </ScrollView>
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
    alignItems: 'center',
    padding: 20,
    paddingTop: 60,
  },
  backButton: {
    padding: 8,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  imageContainer: {
    height: 250,
  },
  speciesImage: {
    width: '100%',
    height: '100%',
  },
  titleContainer: {
    padding: 20,
    paddingTop: 10,
  },
  speciesName: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  scientificName: {
    fontSize: 16,
    color: '#666',
    fontStyle: 'italic',
    marginTop: 4,
  },
  tabs: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    paddingHorizontal: 20,
  },
  tab: {
    paddingVertical: 12,
    paddingHorizontal: 16,
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: '#2196F3',
  },
  tabText: {
    color: '#666',
    fontSize: 14,
  },
  activeTabText: {
    color: '#2196F3',
    fontWeight: 'bold',
  },
  content: {
    flex: 1,
  },
  tabContent: {
    padding: 20,
  },
  description: {
    fontSize: 16,
    lineHeight: 24,
    marginBottom: 20,
  },
  infoCard: {
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 15,
  },
  infoTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  infoText: {
    fontSize: 14,
    color: '#444',
    lineHeight: 20,
  },
}); 