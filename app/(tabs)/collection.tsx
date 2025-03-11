import React, { useState, useCallback } from 'react';
import { StyleSheet, View, Text, FlatList, TouchableOpacity, Image, TextInput, RefreshControl, ScrollView } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';

interface SavedSpecies {
  id: string;
  name: string;
  scientificName: string;
  imageUri: string;
  date: string;
  location: string;
  confidence: number;
  isFavorite: boolean;
  category: 'birds' | 'plants' | 'insects' | 'mammals' | 'other';
}

export default function CollectionScreen() {
  const router = useRouter();
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid');
  const [filterMode, setFilterMode] = useState<'all' | 'recent' | 'favorites'>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<SavedSpecies['category'] | 'all'>('all');
  const [refreshing, setRefreshing] = useState(false);

  const categories: { id: SavedSpecies['category'] | 'all'; icon: string; label: string }[] = [
    { id: 'all', icon: 'apps', label: 'All' },
    { id: 'birds', icon: 'bird', label: 'Birds' },
    { id: 'plants', icon: 'leaf', label: 'Plants' },
    { id: 'insects', icon: 'bug', label: 'Insects' },
    { id: 'mammals', icon: 'dog', label: 'Mammals' },
    { id: 'other', icon: 'dots-horizontal', label: 'Other' },
  ];

  // Mock data with categories and favorites
  const savedSpecies: SavedSpecies[] = [
    {
      id: '1',
      name: 'Red-tailed Hawk',
      scientificName: 'Buteo jamaicensis',
      imageUri: 'https://example.com/hawk.jpg',
      date: '2024-03-20',
      location: 'Central Park, NY',
      confidence: 95,
      isFavorite: true,
      category: 'birds',
    },
    {
      id: '2',
      name: 'Great Blue Heron',
      scientificName: 'Ardea herodias',
      imageUri: 'https://example.com/heron.jpg',
      date: '2024-03-19',
      location: 'Lake Michigan',
      confidence: 98,
      isFavorite: false,
      category: 'birds',
    },
  ];

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    // Simulate data refresh
    setTimeout(() => {
      setRefreshing(false);
    }, 1000);
  }, []);

  const filteredSpecies = savedSpecies.filter(species => {
    const matchesSearch = species.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      species.scientificName.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesFilter = filterMode === 'all' || 
      (filterMode === 'favorites' && species.isFavorite) ||
      (filterMode === 'recent' && new Date(species.date) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000));
    const matchesCategory = selectedCategory === 'all' || species.category === selectedCategory;
    return matchesSearch && matchesFilter && matchesCategory;
  });

  const renderGridItem = ({ item }: { item: SavedSpecies }) => (
    <TouchableOpacity
      style={styles.gridItem}
      onPress={() => router.push({
        pathname: '/species-details',
        params: { species: item.name, imageUri: item.imageUri }
      })}
    >
      <Image source={{ uri: item.imageUri }} style={styles.gridImage} />
      <View style={styles.gridOverlay}>
        <MaterialCommunityIcons 
          name={categories.find(c => c.id === item.category)?.icon || 'help'} 
          size={20} 
          color="#fff" 
        />
      </View>
      <View style={styles.gridInfo}>
        <Text style={styles.gridName} numberOfLines={1}>{item.name}</Text>
        <View style={styles.gridMetadata}>
          <Text style={styles.gridDate}>{item.date}</Text>
          {item.isFavorite && (
            <Ionicons name="heart" size={16} color="#FF4081" />
          )}
        </View>
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
          <View style={styles.listMetadata}>
            <Ionicons name="location-outline" size={14} color="#666" />
            <Text style={styles.listLocation}>{item.location}</Text>
          </View>
          <View style={styles.listMetadata}>
            <Ionicons name="calendar-outline" size={14} color="#666" />
            <Text style={styles.listDate}>{item.date}</Text>
          </View>
          <View style={styles.listMetadata}>
            <MaterialCommunityIcons 
              name={categories.find(c => c.id === item.category)?.icon || 'help'} 
              size={14} 
              color="#666" 
            />
            <Text style={styles.listCategory}>
              {categories.find(c => c.id === item.category)?.label}
            </Text>
          </View>
        </View>
      </View>
      <TouchableOpacity style={styles.favoriteButton}>
        <Ionicons 
          name={item.isFavorite ? "heart" : "heart-outline"} 
          size={24} 
          color={item.isFavorite ? "#FF4081" : "#666"} 
        />
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

      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Ionicons name="search" size={20} color="#666" />
          <TextInput
            style={styles.searchInput}
            placeholder="Search species..."
            value={searchQuery}
            onChangeText={setSearchQuery}
            placeholderTextColor="#666"
          />
          {searchQuery !== '' && (
            <TouchableOpacity onPress={() => setSearchQuery('')}>
              <Ionicons name="close-circle" size={20} color="#666" />
            </TouchableOpacity>
          )}
        </View>
      </View>

      <View style={styles.filterContainer}>
        <ScrollView 
          horizontal 
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.filterScroll}
        >
          {categories.map((category) => (
            <TouchableOpacity
              key={category.id}
              style={[
                styles.categoryButton,
                selectedCategory === category.id && styles.activeCategoryButton,
              ]}
              onPress={() => setSelectedCategory(category.id)}
            >
              <MaterialCommunityIcons
                name={category.icon}
                size={20}
                color={selectedCategory === category.id ? '#fff' : '#666'}
              />
              <Text
                style={[
                  styles.categoryText,
                  selectedCategory === category.id && styles.activeCategoryText,
                ]}
              >
                {category.label}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      <View style={styles.filterTabs}>
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
        data={filteredSpecies}
        renderItem={viewMode === 'grid' ? renderGridItem : renderListItem}
        keyExtractor={(item) => item.id}
        numColumns={viewMode === 'grid' ? 2 : 1}
        key={viewMode}
        contentContainerStyle={styles.listContainer}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
        ListEmptyComponent={() => (
          <View style={styles.emptyContainer}>
            <MaterialCommunityIcons name="magnify-close" size={48} color="#666" />
            <Text style={styles.emptyText}>No species found</Text>
            <Text style={styles.emptySubtext}>Try adjusting your search or filters</Text>
          </View>
        )}
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
    fontSize: 28,
    fontWeight: 'bold',
  },
  viewModeButton: {
    padding: 8,
  },
  searchContainer: {
    paddingHorizontal: 20,
    marginBottom: 15,
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
  filterContainer: {
    marginBottom: 10,
  },
  filterScroll: {
    paddingHorizontal: 15,
  },
  categoryButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginRight: 10,
    borderRadius: 20,
    backgroundColor: '#f5f5f5',
  },
  activeCategoryButton: {
    backgroundColor: '#2196F3',
  },
  categoryText: {
    marginLeft: 6,
    color: '#666',
    fontSize: 14,
  },
  activeCategoryText: {
    color: '#fff',
  },
  filterTabs: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    marginBottom: 10,
  },
  filterButton: {
    flex: 1,
    paddingVertical: 8,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
  },
  activeFilterButton: {
    borderBottomColor: '#2196F3',
  },
  filterText: {
    color: '#666',
    fontSize: 14,
    fontWeight: '500',
  },
  activeFilterText: {
    color: '#2196F3',
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
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  gridImage: {
    width: '100%',
    height: 150,
  },
  gridOverlay: {
    position: 'absolute',
    top: 10,
    left: 10,
    backgroundColor: 'rgba(0,0,0,0.5)',
    padding: 6,
    borderRadius: 15,
  },
  gridInfo: {
    padding: 10,
  },
  gridName: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  gridMetadata: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 4,
  },
  gridDate: {
    fontSize: 12,
    color: '#666',
  },
  listItem: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    marginBottom: 10,
    borderRadius: 10,
    overflow: 'hidden',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
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
  listMetadata: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 4,
  },
  listLocation: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  listDate: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  listCategory: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
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
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  scanButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  emptyContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
  },
  emptyText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#666',
    marginTop: 16,
  },
  emptySubtext: {
    fontSize: 14,
    color: '#999',
    marginTop: 8,
  },
}); 