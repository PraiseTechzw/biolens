import React from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useLocalSearchParams, useRouter } from 'expo-router';

interface SearchParams {
  imageUri: string;
  species: string;
  confidence: string;
}

interface SimilarSpecies {
  name: string;
  scientificName: string;
  similarity: number;
  imageUri: string;
}

export default function ScanResultsScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<SearchParams>();

  const similarSpecies: SimilarSpecies[] = [
    {
      name: 'Cooper\'s Hawk',
      scientificName: 'Accipiter cooperii',
      similarity: 85,
      imageUri: 'https://example.com/coopers-hawk.jpg',
    },
    {
      name: 'Sharp-shinned Hawk',
      scientificName: 'Accipiter striatus',
      similarity: 78,
      imageUri: 'https://example.com/sharp-shinned-hawk.jpg',
    },
  ];

  const speciesData = {
    name: params.species || 'Red-tailed Hawk',
    scientificName: 'Buteo jamaicensis',
    imageUri: params.imageUri || 'https://example.com/hawk.jpg',
    confidence: parseFloat(params.confidence || '95'),
    conservationStatus: 'Least Concern',
    quickFacts: [
      'Common throughout North America',
      'Skilled hunter with excellent eyesight',
      'Distinctive red tail in adult birds',
    ],
  };

  const getConfidenceColor = (confidence: number) => {
    if (confidence >= 90) return '#4CAF50';
    if (confidence >= 70) return '#FFC107';
    return '#FF5252';
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Identification Results</Text>
        <TouchableOpacity style={styles.shareButton}>
          <Ionicons name="share-outline" size={24} color="#000" />
        </TouchableOpacity>
      </View>

      <ScrollView>
        <View style={styles.imageContainer}>
          <Image source={{ uri: speciesData.imageUri }} style={styles.image} />
          <View style={styles.confidenceBadge}>
            <Text style={styles.confidenceText}>
              {speciesData.confidence}% Match
            </Text>
            <View
              style={[
                styles.confidenceBar,
                { width: `${speciesData.confidence}%`, backgroundColor: getConfidenceColor(speciesData.confidence) },
              ]}
            />
          </View>
        </View>

        <View style={styles.contentContainer}>
          <View style={styles.speciesHeader}>
            <View>
              <Text style={styles.speciesName}>{speciesData.name}</Text>
              <Text style={styles.scientificName}>{speciesData.scientificName}</Text>
            </View>
            <TouchableOpacity style={styles.favoriteButton}>
              <Ionicons name="heart-outline" size={24} color="#FF4081" />
            </TouchableOpacity>
          </View>

          <View style={styles.statusContainer}>
            <MaterialCommunityIcons name="shield-check" size={20} color="#4CAF50" />
            <Text style={styles.statusText}>{speciesData.conservationStatus}</Text>
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Quick Facts</Text>
            {speciesData.quickFacts.map((fact, index) => (
              <View key={index} style={styles.factItem}>
                <MaterialCommunityIcons name="circle-medium" size={24} color="#2196F3" />
                <Text style={styles.factText}>{fact}</Text>
              </View>
            ))}
          </View>

          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Similar Species</Text>
            {similarSpecies.map((species, index) => (
              <TouchableOpacity
                key={index}
                style={styles.similarSpeciesCard}
                onPress={() => router.push({
                  pathname: '/species-details',
                  params: { species: species.name }
                })}
              >
                <Image source={{ uri: species.imageUri }} style={styles.similarSpeciesImage} />
                <View style={styles.similarSpeciesInfo}>
                  <Text style={styles.similarSpeciesName}>{species.name}</Text>
                  <Text style={styles.similarSpeciesScientific}>{species.scientificName}</Text>
                  <View style={styles.similarityContainer}>
                    <Text style={styles.similarityText}>{species.similarity}% Similar</Text>
                    <View
                      style={[
                        styles.similarityBar,
                        { width: `${species.similarity}%`, backgroundColor: getConfidenceColor(species.similarity) },
                      ]}
                    />
                  </View>
                </View>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity
          style={styles.actionButton}
          onPress={() => router.push({
            pathname: '/species-details',
            params: { species: speciesData.name, imageUri: speciesData.imageUri }
          })}
        >
          <Text style={styles.actionButtonText}>Learn More</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.actionButton, styles.arButton]}
          onPress={() => router.push('/ar-view')}
        >
          <MaterialCommunityIcons name="augmented-reality" size={24} color="#fff" />
          <Text style={styles.actionButtonText}>View in AR</Text>
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
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  backButton: {
    padding: 8,
  },
  shareButton: {
    padding: 8,
  },
  imageContainer: {
    position: 'relative',
  },
  image: {
    width: '100%',
    height: 300,
  },
  confidenceBadge: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    right: 20,
    backgroundColor: 'rgba(0,0,0,0.7)',
    padding: 10,
    borderRadius: 10,
  },
  confidenceText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
    marginBottom: 5,
  },
  confidenceBar: {
    height: 4,
    borderRadius: 2,
  },
  contentContainer: {
    padding: 20,
  },
  speciesHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  speciesName: {
    fontSize: 24,
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
  statusContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  statusText: {
    fontSize: 14,
    color: '#4CAF50',
    marginLeft: 5,
  },
  section: {
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  factItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  factText: {
    fontSize: 16,
    marginLeft: 5,
    flex: 1,
  },
  similarSpeciesCard: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    marginBottom: 10,
    overflow: 'hidden',
  },
  similarSpeciesImage: {
    width: 100,
    height: 100,
  },
  similarSpeciesInfo: {
    flex: 1,
    padding: 15,
  },
  similarSpeciesName: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  similarSpeciesScientific: {
    fontSize: 14,
    color: '#666',
    fontStyle: 'italic',
    marginBottom: 8,
  },
  similarityContainer: {
    marginTop: 5,
  },
  similarityText: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  similarityBar: {
    height: 4,
    borderRadius: 2,
    backgroundColor: '#2196F3',
  },
  footer: {
    flexDirection: 'row',
    padding: 20,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  actionButton: {
    flex: 1,
    backgroundColor: '#2196F3',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    marginHorizontal: 5,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  arButton: {
    backgroundColor: '#4CAF50',
  },
  actionButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 5,
  },
}); 