import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Image,
  useColorScheme,
  FlatList,
  Dimensions,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { Link } from 'expo-router';

interface Category {
  id: number;
  name: string;
  icon: string;
  count: number;
}

interface Species {
  id: number;
  name: string;
  scientificName: string;
  image: string;
  category: string;
}

const categories: Category[] = [
  { id: 1, name: 'Plants', icon: 'flower', count: 150 },
  { id: 2, name: 'Trees', icon: 'tree', count: 80 },
  { id: 3, name: 'Flowers', icon: 'flower-tulip', count: 120 },
  { id: 4, name: 'Fungi', icon: 'mushroom', count: 45 },
  { id: 5, name: 'Mosses', icon: 'grass', count: 30 },
  { id: 6, name: 'Algae', icon: 'water', count: 25 },
];

const featuredSpecies: Species[] = [
  {
    id: 1,
    name: 'Giant Sequoia',
    scientificName: 'Sequoiadendron giganteum',
    image: 'https://images.unsplash.com/photo-1503785640985-f62e3aeee448',
    category: 'Trees',
  },
  {
    id: 2,
    name: 'Venus Flytrap',
    scientificName: 'Dionaea muscipula',
    image: 'https://images.unsplash.com/photo-1515689917361-d41c8e411ea8',
    category: 'Plants',
  },
];

export default function ExploreScreen() {
  const [searchQuery, setSearchQuery] = useState('');
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';

  const renderCategoryItem = ({ item }: { item: Category }) => (
    <TouchableOpacity
      style={[
        styles.categoryCard,
        { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
      ]}
    >
      <MaterialCommunityIcons
        name={item.icon}
        size={32}
        color="#2E7D32"
      />
      <Text style={[
        styles.categoryName,
        { color: isDark ? '#fff' : '#000' }
      ]}>{item.name}</Text>
      <Text style={styles.categoryCount}>{item.count} species</Text>
    </TouchableOpacity>
  );

  const renderFeaturedItem = ({ item }: { item: Species }) => (
    <TouchableOpacity
      style={[
        styles.featuredCard,
        { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
      ]}
    >
      <Image
        source={{ uri: item.image }}
        style={styles.featuredImage}
      />
      <View style={styles.featuredInfo}>
        <Text style={[
          styles.featuredName,
          { color: isDark ? '#fff' : '#000' }
        ]}>{item.name}</Text>
        <Text style={styles.featuredScientific}>{item.scientificName}</Text>
        <View style={styles.featuredCategory}>
          <MaterialCommunityIcons name="tag" size={16} color="#2E7D32" />
          <Text style={styles.categoryLabel}>{item.category}</Text>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={[
      styles.container,
      { backgroundColor: isDark ? '#121212' : '#fff' }
    ]}>
      <View style={styles.header}>
        <Text style={[
          styles.title,
          { color: isDark ? '#fff' : '#000' }
        ]}>Explore</Text>
        <TouchableOpacity style={styles.scanButton}>
          <MaterialCommunityIcons name="camera" size={24} color="#fff" />
        </TouchableOpacity>
      </View>

      <View style={[
        styles.searchContainer,
        { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
      ]}>
        <MaterialCommunityIcons
          name="magnify"
          size={24}
          color={isDark ? '#aaa' : '#666'}
        />
        <TextInput
          style={[
            styles.searchInput,
            { color: isDark ? '#fff' : '#000' }
          ]}
          placeholder="Search species..."
          placeholderTextColor={isDark ? '#aaa' : '#666'}
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
      </View>

      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.section}>
          <Text style={[
            styles.sectionTitle,
            { color: isDark ? '#fff' : '#000' }
          ]}>Categories</Text>
          <FlatList
            data={categories}
            renderItem={renderCategoryItem}
            keyExtractor={item => item.id.toString()}
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.categoriesList}
          />
        </View>

        <View style={styles.section}>
          <Text style={[
            styles.sectionTitle,
            { color: isDark ? '#fff' : '#000' }
          ]}>Featured Species</Text>
          {featuredSpecies.map(item => (
            <Link
              key={item.id}
              href={{
                pathname: "/species-details",
                params: { id: item.id }
              }}
              asChild
            >
              {renderFeaturedItem({ item })}
            </Link>
          ))}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
  },
  scanButton: {
    backgroundColor: '#2E7D32',
    width: 44,
    height: 44,
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 20,
    paddingHorizontal: 16,
    height: 50,
    borderRadius: 25,
    marginBottom: 24,
  },
  searchInput: {
    flex: 1,
    marginLeft: 12,
    fontSize: 16,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 16,
    paddingHorizontal: 20,
  },
  categoriesList: {
    paddingHorizontal: 20,
    gap: 12,
  },
  categoryCard: {
    width: 100,
    height: 100,
    borderRadius: 20,
    padding: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  categoryName: {
    fontSize: 14,
    fontWeight: '500',
    marginTop: 8,
    textAlign: 'center',
  },
  categoryCount: {
    fontSize: 12,
    color: '#2E7D32',
    marginTop: 4,
  },
  featuredCard: {
    marginHorizontal: 20,
    marginBottom: 16,
    borderRadius: 20,
    overflow: 'hidden',
  },
  featuredImage: {
    width: '100%',
    height: 200,
  },
  featuredInfo: {
    padding: 16,
  },
  featuredName: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 4,
  },
  featuredScientific: {
    fontSize: 14,
    color: '#2E7D32',
    fontStyle: 'italic',
    marginBottom: 8,
  },
  featuredCategory: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  categoryLabel: {
    marginLeft: 6,
    color: '#2E7D32',
    fontSize: 14,
  },
}); 