import React, { useState } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, Image, ScrollView, Dimensions } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter, useLocalSearchParams } from 'expo-router';

const { width } = Dimensions.get('window');

interface ARFeature {
  id: string;
  title: string;
  description: string;
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  comingSoon?: boolean;
}

export default function ARViewScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ species: string }>();
  const [selectedMode, setSelectedMode] = useState<'3d' | 'life-size'>('3d');

  const arFeatures: ARFeature[] = [
    {
      id: '1',
      title: '3D Visualization',
      description: 'View detailed 3D models with animations',
      icon: 'rotate-3d',
    },
    {
      id: '2',
      title: 'Life-size Mode',
      description: 'Experience true-to-life scaling in your environment',
      icon: 'ruler',
    },
    {
      id: '3',
      title: 'Interactive Hotspots',
      description: 'Tap to learn about specific features',
      icon: 'cursor-pointer',
      comingSoon: true,
    },
    {
      id: '4',
      title: 'Behavioral Animations',
      description: 'Watch natural behaviors and movements',
      icon: 'animation-play',
      comingSoon: true,
    },
  ];

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <Ionicons name="arrow-back" size={24} color="#000" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>AR Experience</Text>
        <TouchableOpacity style={styles.helpButton}>
          <Ionicons name="help-circle-outline" size={24} color="#000" />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        <View style={styles.previewContainer}>
          <Image 
            source={{ uri: 'https://example.com/ar-preview.jpg' }}
            style={styles.previewImage}
          />
          <View style={styles.speciesInfo}>
            <Text style={styles.speciesName}>{params.species || 'Species'}</Text>
            <Text style={styles.speciesSubtitle}>Augmented Reality Preview</Text>
          </View>
        </View>

        <View style={styles.modeSelector}>
          <TouchableOpacity 
            style={[styles.modeButton, selectedMode === '3d' && styles.modeButtonActive]}
            onPress={() => setSelectedMode('3d')}
          >
            <MaterialCommunityIcons 
              name="rotate-3d" 
              size={24} 
              color={selectedMode === '3d' ? '#fff' : '#666'} 
            />
            <Text style={[styles.modeButtonText, selectedMode === '3d' && styles.modeButtonTextActive]}>
              3D View
            </Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={[styles.modeButton, selectedMode === 'life-size' && styles.modeButtonActive]}
            onPress={() => setSelectedMode('life-size')}
          >
            <MaterialCommunityIcons 
              name="ruler" 
              size={24} 
              color={selectedMode === 'life-size' ? '#fff' : '#666'} 
            />
            <Text style={[styles.modeButtonText, selectedMode === 'life-size' && styles.modeButtonTextActive]}>
              Life-size
            </Text>
          </TouchableOpacity>
        </View>

        <View style={styles.featuresGrid}>
          {arFeatures.map((feature) => (
            <View key={feature.id} style={styles.featureCard}>
              <View style={[styles.featureIcon, feature.comingSoon && styles.featureIconDisabled]}>
                <MaterialCommunityIcons name={feature.icon} size={28} color={feature.comingSoon ? '#999' : '#00796B'} />
              </View>
              <Text style={styles.featureTitle}>{feature.title}</Text>
              <Text style={styles.featureDescription}>{feature.description}</Text>
              {feature.comingSoon && (
                <View style={styles.comingSoonBadge}>
                  <Text style={styles.comingSoonText}>Coming Soon</Text>
                </View>
              )}
            </View>
          ))}
        </View>

        <View style={styles.startSection}>
          <TouchableOpacity style={styles.startButton}>
            <MaterialCommunityIcons name="augmented-reality" size={24} color="#fff" />
            <Text style={styles.startButtonText}>Start AR Experience</Text>
          </TouchableOpacity>
          <Text style={styles.disclaimer}>
            Point your camera at a flat surface to begin
          </Text>
        </View>
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
    justifyContent: 'space-between',
    padding: 20,
    paddingTop: 60,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  backButton: {
    padding: 8,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  helpButton: {
    padding: 8,
  },
  content: {
    flex: 1,
  },
  previewContainer: {
    margin: 20,
    borderRadius: 15,
    overflow: 'hidden',
    backgroundColor: '#f5f5f5',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  previewImage: {
    width: '100%',
    height: 200,
    backgroundColor: '#e0e0e0',
  },
  speciesInfo: {
    padding: 15,
  },
  speciesName: {
    fontSize: 22,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  speciesSubtitle: {
    fontSize: 14,
    color: '#666',
  },
  modeSelector: {
    flexDirection: 'row',
    marginHorizontal: 20,
    marginBottom: 20,
    backgroundColor: '#f5f5f5',
    borderRadius: 12,
    padding: 4,
  },
  modeButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 12,
    borderRadius: 10,
  },
  modeButtonActive: {
    backgroundColor: '#00796B',
  },
  modeButtonText: {
    marginLeft: 8,
    fontSize: 16,
    color: '#666',
  },
  modeButtonTextActive: {
    color: '#fff',
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    padding: 10,
  },
  featureCard: {
    width: (width - 60) / 2,
    margin: 10,
    padding: 15,
    backgroundColor: '#fff',
    borderRadius: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  featureIcon: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: '#E0F2F1',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  featureIconDisabled: {
    backgroundColor: '#f5f5f5',
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 6,
  },
  featureDescription: {
    fontSize: 13,
    color: '#666',
    lineHeight: 18,
  },
  comingSoonBadge: {
    position: 'absolute',
    top: 10,
    right: 10,
    backgroundColor: '#FFD700',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
  },
  comingSoonText: {
    fontSize: 10,
    fontWeight: 'bold',
    color: '#000',
  },
  startSection: {
    padding: 20,
    alignItems: 'center',
  },
  startButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#00796B',
    paddingHorizontal: 24,
    paddingVertical: 16,
    borderRadius: 12,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  startButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  disclaimer: {
    marginTop: 12,
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
  },
}); 