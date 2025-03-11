import React, { useState } from 'react';
import { StyleSheet, View, Text, FlatList, TouchableOpacity, Image } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';

interface SavedSpecies {
  id: string;
  name: string;
  scientificName: string;
  imageUri: string;
  date: string;
  location: string;
  confidence: number;
}

export default function CollectionScreen() {
  const router = useRouter();
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid');
  const [filterMode, setFilterMode] = useState<'all' | 'recent' | 'favorites'>('all');

  // Mock data - in a real app, this would come from a database or API
  const savedSpecies: SavedSpecies[] = [
    {
      id: '1',
      name: 'Red-tailed Hawk',
      scientificName: 'Buteo jamaicensis',
      imageUri: 'https://example.com/hawk.jpg',
      date: '2024-03-20',
      location: 'Central Park, NY',
      confidence: 95,
    },
    {
      id: '2',
      name: 'Great Blue Heron',
      scientificName: 'Ardea herodias',
      imageUri: 'https://example.com/heron.jpg',
      date: '2024-03-19',
      location: 'Lake Michigan',
      confidence: 98,
    },
    // Add more mock data as needed
  ];

  const renderGridItem = ({ item }: { item: SavedSpecies }) => (
    <TouchableOpacity
      style={styles.gridItem}
      onPress={() => router.push({
        pathname: '/species-details',
        params: { species: item.name, imageUri: item.imageUri }
      })}
    >
      <Image source={{ uri: item.imageUri }} style={styles.gridImage} />
      <View style={styles.gridInfo}>
        <Text style={styles.gridName} numberOfLines={1}>{item.name}</Text>
        <Text style={styles.gridDate}>{item.date}</Text>
      </View>
    </TouchableOpacity>
  );

  const renderListItem = ({ item }: { item: SavedSpecies }) => (
    <TouchableOpacity
      style={styles.listItem}
      onPress={() => router.push({
        pathname: '/species-details',
        params: { species: item.name, imageUri: item.imageUri }
      })}
    >
      <Image source={{ uri: item.imageUri }} style={styles.listImage} />
      <View style={styles.listInfo}>
        <Text style={styles.listName}>{item.name}</Text>
        <Text style={styles.listScientific}>{item.scientificName}</Text>
        <View style={styles.listDetails}>
          <Text style={styles.listLocation}>{item.location}</Text>
          <Text style={styles.listDate}>{item.date}</Text>
        </View>
      </View>
      <TouchableOpacity style={styles.favoriteButton}>
        <Ionicons name="heart-outline" size={24} color="#666" />
      </TouchableOpacity>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>My Collection</Text>
        <TouchableOpacity
          onPress={() => setViewMode(viewMode === 'grid' ? 'list' : 'grid')}
          style={styles.viewModeButton}
        >
          <Ionicons
            name={viewMode === 'grid' ? 'list' : 'grid'}
            size={24}
            color="#000"
          />
        </TouchableOpacity>
      </View>

      <View style={styles.filterContainer}>
        {(['all', 'recent', 'favorites'] as const).map((filter) => (
          <TouchableOpacity
            key={filter}
            style={[
              styles.filterButton,
              filterMode === filter && styles.activeFilterButton,
            ]}
            onPress={() => setFilterMode(filter)}
          >
            <Text
              style={[
                styles.filterText,
                filterMode === filter && styles.activeFilterText,
              ]}
            >
              {filter.charAt(0).toUpperCase() + filter.slice(1)}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      <FlatList
        data={savedSpecies}
        renderItem={viewMode === 'grid' ? renderGridItem : renderListItem}
        keyExtractor={(item) => item.id}
        numColumns={viewMode === 'grid' ? 2 : 1}
        key={viewMode} // Force re-render when changing view mode
        contentContainerStyle={styles.listContainer}
      />

      <TouchableOpacity
        style={styles.scanButton}
        onPress={() => router.push('/')}
      >
        <Ionicons name="camera" size={24} color="#fff" />
        <Text style={styles.scanButtonText}>Scan New Species</Text>
      </TouchableOpacity>
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
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  viewModeButton: {
    padding: 8,
  },
  filterContainer: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    marginBottom: 10,
  },
  filterButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginRight: 10,
    borderRadius: 20,
    backgroundColor: '#f5f5f5',
  },
  activeFilterButton: {
    backgroundColor: '#2196F3',
  },
  filterText: {
    color: '#666',
    fontSize: 14,
  },
  activeFilterText: {
    color: '#fff',
    fontWeight: 'bold',
  },
  listContainer: {
    padding: 10,
  },
  gridItem: {
    flex: 1,
    margin: 5,
    borderRadius: 10,
    overflow: 'hidden',
    backgroundColor: '#f5f5f5',
  },
  gridImage: {
    width: '100%',
    height: 150,
  },
  gridInfo: {
    padding: 10,
  },
  gridName: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  gridDate: {
    fontSize: 12,
    color: '#666',
    marginTop: 4,
  },
  listItem: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    marginBottom: 10,
    borderRadius: 10,
    overflow: 'hidden',
  },
  listImage: {
    width: 100,
    height: 100,
  },
  listInfo: {
    flex: 1,
    padding: 15,
  },
  listName: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  listScientific: {
    fontSize: 14,
    color: '#666',
    fontStyle: 'italic',
    marginTop: 2,
  },
  listDetails: {
    marginTop: 8,
  },
  listLocation: {
    fontSize: 12,
    color: '#666',
  },
  listDate: {
    fontSize: 12,
    color: '#666',
    marginTop: 2,
  },
  favoriteButton: {
    padding: 15,
    justifyContent: 'center',
  },
  scanButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#2196F3',
    margin: 20,
    padding: 15,
    borderRadius: 10,
  },
  scanButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 10,
  },
}); 