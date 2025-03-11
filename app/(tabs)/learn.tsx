import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity, Image, TextInput, Animated } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

interface LearningModule {
  id: string;
  title: string;
  description: string;
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  progress: number;
  totalLessons: number;
  completedLessons: number;
  estimatedTime: string;
  level: 'Beginner' | 'Intermediate' | 'Advanced';
}

interface Guide {
  id: string;
  title: string;
  description: string;
  imageUri: string;
  duration: string;
  difficulty: 'Beginner' | 'Intermediate' | 'Advanced';
  likes: number;
  isBookmarked: boolean;
}

interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  progress: number;
  isUnlocked: boolean;
}

export default function LearnScreen() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedLevel, setSelectedLevel] = useState<'all' | LearningModule['level']>('all');

  const learningModules: LearningModule[] = [
    {
      id: '1',
      title: 'Basic Biology',
      description: 'Learn fundamental concepts of biology and life sciences',
      icon: 'dna',
      progress: 45,
      totalLessons: 12,
      completedLessons: 5,
      estimatedTime: '4 hours',
      level: 'Beginner',
    },
    {
      id: '2',
      title: 'Species Classification',
      description: 'Understanding taxonomy and species identification',
      icon: 'leaf',
      progress: 30,
      totalLessons: 8,
      completedLessons: 2,
      estimatedTime: '3 hours',
      level: 'Intermediate',
    },
    {
      id: '3',
      title: 'Ecosystems',
      description: 'Explore different habitats and their inhabitants',
      icon: 'forest',
      progress: 60,
      totalLessons: 10,
      completedLessons: 6,
      estimatedTime: '5 hours',
      level: 'Advanced',
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
      likes: 245,
      isBookmarked: true,
    },
    {
      id: '2',
      title: 'Plant Identification',
      description: 'Tips and tricks for identifying wild plants safely',
      imageUri: 'https://example.com/plants.jpg',
      duration: '20 min',
      difficulty: 'Intermediate',
      likes: 189,
      isBookmarked: false,
    },
  ];

  const achievements: Achievement[] = [
    {
      id: '1',
      title: 'Nature Explorer',
      description: 'Complete 5 species identifications',
      icon: 'compass',
      progress: 60,
      isUnlocked: false,
    },
    {
      id: '2',
      title: 'Bird Expert',
      description: 'Identify 10 different bird species',
      icon: 'bird',
      progress: 100,
      isUnlocked: true,
    },
  ];

  const renderProgressBar = (progress: number) => (
    <View style={styles.progressBarContainer}>
      <View style={[styles.progressBar, { width: `${progress}%` }]} />
    </View>
  );

  const renderLevelBadge = (level: LearningModule['level']) => {
    const colors = {
      Beginner: '#4CAF50',
      Intermediate: '#FF9800',
      Advanced: '#F44336',
    };

    return (
      <View style={[styles.levelBadge, { backgroundColor: colors[level] }]}>
        <Text style={styles.levelText}>{level}</Text>
      </View>
    );
  };

  const filteredModules = learningModules.filter(module => {
    const matchesSearch = module.title.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesLevel = selectedLevel === 'all' || module.level === selectedLevel;
    return matchesSearch && matchesLevel;
  });

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Learn</Text>
        <TouchableOpacity style={styles.profileButton}>
          <MaterialCommunityIcons name="account-circle" size={32} color="#2196F3" />
        </TouchableOpacity>
      </View>

      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Ionicons name="search" size={20} color="#666" />
          <TextInput
            style={styles.searchInput}
            placeholder="Search modules and guides..."
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

      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        style={styles.levelFilter}
        contentContainerStyle={styles.levelFilterContent}
      >
        {(['all', 'Beginner', 'Intermediate', 'Advanced'] as const).map((level) => (
          <TouchableOpacity
            key={level}
            style={[
              styles.levelButton,
              selectedLevel === level && styles.activeLevelButton,
            ]}
            onPress={() => setSelectedLevel(level)}
          >
            <Text
              style={[
                styles.levelButtonText,
                selectedLevel === level && styles.activeLevelButtonText,
              ]}
            >
              {level === 'all' ? 'All Levels' : level}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Learning Modules</Text>
          <TouchableOpacity>
            <Text style={styles.seeAllButton}>See All</Text>
          </TouchableOpacity>
        </View>
        {filteredModules.map((module) => (
          <TouchableOpacity key={module.id} style={styles.moduleCard}>
            <View style={styles.moduleIconContainer}>
              <MaterialCommunityIcons name={module.icon} size={32} color="#2196F3" />
            </View>
            <View style={styles.moduleInfo}>
              <View style={styles.moduleHeader}>
                <Text style={styles.moduleTitle}>{module.title}</Text>
                {renderLevelBadge(module.level)}
              </View>
              <Text style={styles.moduleDescription} numberOfLines={2}>
                {module.description}
              </Text>
              <View style={styles.moduleProgress}>
                {renderProgressBar(module.progress)}
                <View style={styles.moduleStats}>
                  <Text style={styles.progressText}>
                    {module.completedLessons}/{module.totalLessons} Lessons
                  </Text>
                  <Text style={styles.estimatedTime}>
                    <Ionicons name="time-outline" size={14} color="#666" />
                    {' '}{module.estimatedTime}
                  </Text>
                </View>
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </View>

      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Quick Guides</Text>
          <TouchableOpacity>
            <Text style={styles.seeAllButton}>See All</Text>
          </TouchableOpacity>
        </View>
        {guides.map((guide) => (
          <TouchableOpacity key={guide.id} style={styles.guideCard}>
            <Image source={{ uri: guide.imageUri }} style={styles.guideImage} />
            <View style={styles.guideOverlay}>
              <Text style={styles.guideDuration}>
                <Ionicons name="time-outline" size={14} color="#fff" />
                {' '}{guide.duration}
              </Text>
            </View>
            <View style={styles.guideInfo}>
              <Text style={styles.guideTitle}>{guide.title}</Text>
              <Text style={styles.guideDescription} numberOfLines={2}>
                {guide.description}
              </Text>
              <View style={styles.guideMetadata}>
                <View style={styles.guideDifficulty}>
                  <Ionicons name="stats-chart" size={16} color="#666" />
                  <Text style={styles.metadataText}>{guide.difficulty}</Text>
                </View>
                <View style={styles.guideActions}>
                  <TouchableOpacity style={styles.actionButton}>
                    <Ionicons name="heart" size={16} color="#FF4081" />
                    <Text style={styles.actionText}>{guide.likes}</Text>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.actionButton}>
                    <Ionicons
                      name={guide.isBookmarked ? "bookmark" : "bookmark-outline"}
                      size={16}
                      color="#666"
                    />
                  </TouchableOpacity>
                </View>
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Achievements</Text>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.achievementsContainer}
        >
          {achievements.map((achievement) => (
            <View key={achievement.id} style={styles.achievementCard}>
              <View style={[
                styles.achievementIcon,
                achievement.isUnlocked && styles.unlockedAchievement
              ]}>
                <MaterialCommunityIcons
                  name={achievement.icon as keyof typeof MaterialCommunityIcons.glyphMap}
                  size={32}
                  color={achievement.isUnlocked ? '#FFD700' : '#666'}
                />
              </View>
              <Text style={styles.achievementTitle}>{achievement.title}</Text>
              <Text style={styles.achievementDescription} numberOfLines={2}>
                {achievement.description}
              </Text>
              {!achievement.isUnlocked && (
                <View style={styles.achievementProgress}>
                  {renderProgressBar(achievement.progress)}
                  <Text style={styles.achievementProgressText}>
                    {achievement.progress}%
                  </Text>
                </View>
              )}
            </View>
          ))}
        </ScrollView>
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
          <TouchableOpacity style={styles.startChallengeButton}>
            <Text style={styles.startChallengeText}>Start Challenge</Text>
          </TouchableOpacity>
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
  profileButton: {
    padding: 4,
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
  levelFilter: {
    marginBottom: 20,
  },
  levelFilterContent: {
    paddingHorizontal: 15,
  },
  levelButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginRight: 10,
    borderRadius: 20,
    backgroundColor: '#f5f5f5',
  },
  activeLevelButton: {
    backgroundColor: '#2196F3',
  },
  levelButtonText: {
    color: '#666',
    fontSize: 14,
    fontWeight: '500',
  },
  activeLevelButtonText: {
    color: '#fff',
    fontWeight: 'bold',
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
  },
  seeAllButton: {
    color: '#2196F3',
    fontSize: 14,
    fontWeight: '500',
  },
  moduleCard: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 10,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  moduleIconContainer: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: '#E3F2FD',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 15,
  },
  moduleInfo: {
    flex: 1,
  },
  moduleHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 4,
  },
  moduleTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    flex: 1,
  },
  levelBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    marginLeft: 8,
  },
  levelText: {
    color: '#fff',
    fontSize: 12,
    fontWeight: 'bold',
  },
  moduleDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
  },
  moduleProgress: {
    marginTop: 8,
  },
  moduleStats: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 4,
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
  estimatedTime: {
    fontSize: 12,
    color: '#666',
  },
  guideCard: {
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
  guideImage: {
    width: '100%',
    height: 150,
  },
  guideOverlay: {
    position: 'absolute',
    top: 10,
    right: 10,
    backgroundColor: 'rgba(0,0,0,0.5)',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 15,
  },
  guideDuration: {
    color: '#fff',
    fontSize: 12,
    fontWeight: '500',
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
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  guideDifficulty: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  metadataText: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  guideActions: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    marginLeft: 15,
  },
  actionText: {
    fontSize: 12,
    color: '#666',
    marginLeft: 4,
  },
  achievementsContainer: {
    paddingVertical: 10,
  },
  achievementCard: {
    width: 150,
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    padding: 15,
    marginRight: 10,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  achievementIcon: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: '#E0E0E0',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  unlockedAchievement: {
    backgroundColor: '#FFF8E1',
  },
  achievementTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  achievementDescription: {
    fontSize: 12,
    color: '#666',
    marginBottom: 8,
  },
  achievementProgress: {
    marginTop: 8,
  },
  achievementProgressText: {
    fontSize: 12,
    color: '#666',
    marginTop: 4,
    textAlign: 'center',
  },
  challengeCard: {
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
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
    marginBottom: 15,
  },
  challengeProgressText: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  startChallengeButton: {
    backgroundColor: '#2196F3',
    padding: 12,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 10,
  },
  startChallengeText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: 'bold',
  },
}); 