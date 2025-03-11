import React from 'react';
import { StyleSheet, View, Text, Image, ScrollView, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';

export default function ScanResultsScreen() {
  const router = useRouter();
  
  // Mock data - in real app this would come from API/state
  const speciesData = {
    name: 'Red-tailed Hawk',
    scientificName: 'Buteo jamaicensis',
    conservationStatus: 'Least Concern',
    image: 'https://example.com/hawk.jpg',
    quickFacts: [
      { title: 'Diet', content: 'Small mammals, birds' },
      { title: 'Lifespan', content: '10-15 years' },
      { title: 'Habitat', content: 'Woodlands, grasslands' },
    ],
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000" />
        </TouchableOpacity>
        <TouchableOpacity style={styles.saveButton}>
          <Ionicons name="bookmark-outline" size={24} color="#000" />
        </TouchableOpacity>
      </View>

      <View style={styles.imageContainer}>
        <Image
          source={{ uri: speciesData.image }}
          style={styles.speciesImage}
          resizeMode="cover"
        />
        <View style={styles.statusBadge}>
          <Text style={styles.statusText}>{speciesData.conservationStatus}</Text>
        </View>
      </View>

      <View style={styles.infoContainer}>
        <Text style={styles.speciesName}>{speciesData.name}</Text>
        <Text style={styles.scientificName}>{speciesData.scientificName}</Text>

        <View style={styles.quickFactsContainer}>
          <Text style={styles.sectionTitle}>Quick Facts</Text>
          {speciesData.quickFacts.map((fact, index) => (
            <View key={index} style={styles.factCard}>
              <Text style={styles.factTitle}>{fact.title}</Text>
              <Text style={styles.factContent}>{fact.content}</Text>
            </View>
          ))}
        </View>

        <TouchableOpacity style={styles.exploreButton}>
          <Text style={styles.exploreButtonText}>Explore in AR</Text>
        </TouchableOpacity>

        <View style={styles.disclaimer}>
          <Text style={styles.disclaimerText}>
            AI-powered identification with 95% confidence
          </Text>
        </View>
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
  backButton: {
    padding: 8,
  },
  saveButton: {
    padding: 8,
  },
  imageContainer: {
    position: 'relative',
    height: 300,
  },
  speciesImage: {
    width: '100%',
    height: '100%',
  },
  statusBadge: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    backgroundColor: '#4CAF50',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
  },
  statusText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
  },
  infoContainer: {
    padding: 20,
  },
  speciesName: {
    fontSize: 28,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  scientificName: {
    fontSize: 18,
    color: '#666',
    fontStyle: 'italic',
    marginBottom: 20,
  },
  quickFactsContainer: {
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 12,
  },
  factCard: {
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
  },
  factTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  factContent: {
    fontSize: 16,
    color: '#444',
  },
  exploreButton: {
    backgroundColor: '#2196F3',
    padding: 16,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 20,
  },
  exploreButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  disclaimer: {
    alignItems: 'center',
  },
  disclaimerText: {
    color: '#666',
    fontSize: 14,
  },
}); 