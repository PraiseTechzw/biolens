import React from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

interface LearningModule {
  id: string;
  title: string;
  description: string;
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  progress: number;
}

interface Guide {
  id: string;
  title: string;
  description: string;
  imageUri: string;
  duration: string;
  difficulty: 'Beginner' | 'Intermediate' | 'Advanced';
}

export default function LearnScreen() {
  const router = useRouter();

  const learningModules: LearningModule[] = [
    {
      id: '1',
      title: 'Basic Biology',
      description: 'Learn fundamental concepts of biology and life sciences',
      icon: 'dna',
      progress: 45,
    },
    {
      id: '2',
      title: 'Species Classification',
      description: 'Understanding taxonomy and species identification',
      icon: 'leaf',
      progress: 30,
    },
    {
      id: '3',
      title: 'Ecosystems',
      description: 'Explore different habitats and their inhabitants',
      icon: 'forest',
      progress: 60,
    },
  ];

  const guides: Guide[] = [
    {
      id: '1',
      title: 'Bird Watching Basics',
      description: 'Learn how to identify common bird species in your area',
      imageUri: 'https://example.com/birdwatching.jpg',
      duration: '15 min',
      difficulty: 'Beginner',
    },
    {
      id: '2',
      title: 'Plant Identification',
      description: 'Tips and tricks for identifying wild plants safely',
      imageUri: 'https://example.com/plants.jpg',
      duration: '20 min',
      difficulty: 'Intermediate',
    },
  ];

  const renderProgressBar = (progress: number) => (
    <View style={styles.progressBarContainer}>
      <View style={[styles.progressBar, { width: `${progress}%` }]} />
    </View>
  );

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Learn</Text>
      </View>

      <View style={styles.searchContainer}>
        <TouchableOpacity style={styles.searchBar}>
          <Ionicons name="search" size={20} color="#666" />
          <Text style={styles.searchPlaceholder}>Search learning resources...</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Learning Modules</Text>
        {learningModules.map((module) => (
          <TouchableOpacity key={module.id} style={styles.moduleCard}>
            <MaterialCommunityIcons name={module.icon} size={32} color="#2196F3" />
            <View style={styles.moduleInfo}>
              <Text style={styles.moduleTitle}>{module.title}</Text>
              <Text style={styles.moduleDescription} numberOfLines={2}>
                {module.description}
              </Text>
              {renderProgressBar(module.progress)}
              <Text style={styles.progressText}>{module.progress}% Complete</Text>
            </View>
          </TouchableOpacity>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Quick Guides</Text>
        {guides.map((guide) => (
          <TouchableOpacity key={guide.id} style={styles.guideCard}>
            <Image source={{ uri: guide.imageUri }} style={styles.guideImage} />
            <View style={styles.guideInfo}>
              <Text style={styles.guideTitle}>{guide.title}</Text>
              <Text style={styles.guideDescription} numberOfLines={2}>
                {guide.description}
              </Text>
              <View style={styles.guideMetadata}>
                <View style={styles.metadataItem}>
                  <Ionicons name="time-outline" size={16} color="#666" />
                  <Text style={styles.metadataText}>{guide.duration}</Text>
                </View>
                <View style={styles.metadataItem}>
                  <Ionicons name="stats-chart" size={16} color="#666" />
                  <Text style={styles.metadataText}>{guide.difficulty}</Text>
                </View>
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Daily Challenge</Text>
        <TouchableOpacity style={styles.challengeCard}>
          <View style={styles.challengeHeader}>
            <MaterialCommunityIcons name="star" size={24} color="#FFD700" />
            <Text style={styles.challengeTitle}>Identify 3 Species</Text>
          </View>
          <Text style={styles.challengeDescription}>
            Complete today's challenge to earn points and unlock achievements!
          </Text>
          <View style={styles.challengeProgress}>
            <Text style={styles.challengeProgressText}>1/3 Completed</Text>
            {renderProgressBar(33)}
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
    padding: 20,
    paddingTop: 60,
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  searchContainer: {
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
    padding: 12,
    borderRadius: 10,
  },
  searchPlaceholder: {
    marginLeft: 10,
    color: '#666',
    fontSize: 16,
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  moduleCard: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
  },
  moduleInfo: {
    flex: 1,
    marginLeft: 15,
  },
  moduleTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  moduleDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
  },
  progressBarContainer: {
    height: 4,
    backgroundColor: '#E0E0E0',
    borderRadius: 2,
    marginBottom: 4,
  },
  progressBar: {
    height: '100%',
    backgroundColor: '#2196F3',
    borderRadius: 2,
  },
  progressText: {
    fontSize: 12,
    color: '#666',
  },
  guideCard: {
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    marginBottom: 10,
    overflow: 'hidden',
  },
  guideImage: {
    width: '100%',
    height: 150,
  },
  guideInfo: {
    padding: 15,
  },
  guideTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  guideDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
  },
  guideMetadata: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metadataItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 15,
  },
  metadataText: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  challengeCard: {
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
  },
  challengeHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  challengeTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  challengeDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 15,
  },
  challengeProgress: {
    marginTop: 10,
  },
  challengeProgressText: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
}); 