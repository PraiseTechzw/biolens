import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image, TextInput } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

interface Category {
  id: string;
  name: string;
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  count: number;
}

interface FeaturedSpecies {
  id: string;
  name: string;
  scientificName: string;
  imageUri: string;
  category: string;
  distance: string;
}

export default function ExploreScreen() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');

  const categories: Category[] = [
    { id: '1', name: 'Birds', icon: 'bird', count: 150 },
    { id: '2', name: 'Plants', icon: 'flower', count: 200 },
    { id: '3', name: 'Insects', icon: 'bug', count: 120 },
    { id: '4', name: 'Mammals', icon: 'dog', count: 80 },
    { id: '5', name: 'Reptiles', icon: 'snake', count: 50 },
    { id: '6', name: 'Fish', icon: 'fish', count: 90 },
  ];

  const featuredSpecies: FeaturedSpecies[] = [
    {
      id: '1',
      name: 'Red-tailed Hawk',
      scientificName: 'Buteo jamaicensis',
      imageUri: 'https://example.com/hawk.jpg',
      category: 'Birds',
      distance: '2.5 km',
    },
    {
      id: '2',
      name: 'Monarch Butterfly',
      scientificName: 'Danaus plexippus',
      imageUri: 'https://example.com/butterfly.jpg',
      category: 'Insects',
      distance: '1.8 km',
    },
  ];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Explore</Text>
        <TouchableOpacity style={styles.mapButton}>
          <Ionicons name="map" size={24} color="#2196F3" />
        </TouchableOpacity>
      </View>

      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Ionicons name="search" size={20} color="#666" />
          <TextInput
            style={styles.searchInput}
            placeholder="Search species, categories..."
            value={searchQuery}
            onChangeText={setSearchQuery}
            placeholderTextColor="#666"
          />
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Categories</Text>
        <View style={styles.categoriesGrid}>
          {categories.map((category) => (
            <TouchableOpacity
              key={category.id}
              style={styles.categoryCard}
              onPress={() => router.push({
                pathname: '/category-details',
                params: { category: category.name }
              })}
            >
              <View style={styles.categoryIcon}>
                <MaterialCommunityIcons name={category.icon} size={32} color="#2196F3" />
              </View>
              <Text style={styles.categoryName}>{category.name}</Text>
              <Text style={styles.categoryCount}>{category.count} species</Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Featured Species</Text>
          <TouchableOpacity>
            <Text style={styles.seeAllButton}>See All</Text>
          </TouchableOpacity>
        </View>
        {featuredSpecies.map((species) => (
          <TouchableOpacity
            key={species.id}
            style={styles.speciesCard}
            onPress={() => router.push({
              pathname: '/species-details',
              params: { species: species.name }
            })}
          >
            <Image source={{ uri: species.imageUri }} style={styles.speciesImage} />
            <View style={styles.speciesInfo}>
              <Text style={styles.speciesName}>{species.name}</Text>
              <Text style={styles.speciesScientific}>{species.scientificName}</Text>
              <View style={styles.speciesMetadata}>
                <View style={styles.metadataItem}>
                  <MaterialCommunityIcons name="tag" size={16} color="#666" />
                  <Text style={styles.metadataText}>{species.category}</Text>
                </View>
                <View style={styles.metadataItem}>
                  <Ionicons name="location" size={16} color="#666" />
                  <Text style={styles.metadataText}>{species.distance}</Text>
                </View>
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Nearby Sightings</Text>
        <TouchableOpacity style={styles.mapPreview}>
          <Image
            source={{ uri: 'https://example.com/map-preview.jpg' }}
            style={styles.mapImage}
          />
          <View style={styles.mapOverlay}>
            <Text style={styles.mapText}>View Map</Text>
            <Ionicons name="arrow-forward" size={20} color="#fff" />
          </View>
        </TouchableOpacity>
      </View>
    </ScrollView>
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
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
  },
  mapButton: {
    padding: 8,
  },
  searchContainer: {
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
    paddingHorizontal: 15,
    borderRadius: 10,
    height: 44,
  },
  searchInput: {
    flex: 1,
    marginLeft: 10,
    fontSize: 16,
    color: '#000',
  },
  section: {
    padding: 20,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 15,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  seeAllButton: {
    color: '#2196F3',
    fontSize: 14,
    fontWeight: '500',
  },
  categoriesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  categoryCard: {
    width: '48%',
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    padding: 15,
    marginBottom: 15,
    alignItems: 'center',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  categoryIcon: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: '#E3F2FD',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  categoryName: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  categoryCount: {
    fontSize: 12,
    color: '#666',
  },
  speciesCard: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    marginBottom: 10,
    overflow: 'hidden',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  speciesImage: {
    width: 100,
    height: 100,
  },
  speciesInfo: {
    flex: 1,
    padding: 15,
  },
  speciesName: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  speciesScientific: {
    fontSize: 14,
    color: '#666',
    fontStyle: 'italic',
    marginBottom: 8,
  },
  speciesMetadata: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  metadataItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metadataText: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  mapPreview: {
    height: 150,
    borderRadius: 10,
    overflow: 'hidden',
  },
  mapImage: {
    width: '100%',
    height: '100%',
  },
  mapOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 15,
  },
  mapText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
