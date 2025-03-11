import React from 'react';
import { StyleSheet, View, Text, ScrollView, Image, TouchableOpacity, FlatList } from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';

// Mock data - in real app this would come from API/state
const mockUserData = {
  name: 'Jane Doe',
  scans: 47,
  accuracy: 95,
  savedScans: [
    {
      id: '1',
      species: 'Red-tailed Hawk',
      date: '2024-03-11',
      image: 'https://example.com/hawk.jpg',
    },
    {
      id: '2',
      species: 'Eastern Bluebird',
      date: '2024-03-10',
      image: 'https://example.com/bluebird.jpg',
    },
    // Add more mock data as needed
  ],
  badges: [
    {
      id: '1',
      title: 'Botany Beginner',
      icon: 'leaf',
      description: 'Identified 10 plant species',
    },
    {
      id: '2',
      title: 'Bird Watcher',
      icon: 'bird',
      description: 'Identified 5 bird species',
    },
  ],
};

export default function ProfileScreen() {
  const renderScanItem = ({ item }) => (
    <TouchableOpacity style={styles.scanItem}>
      <Image source={{ uri: item.image }} style={styles.scanImage} />
      <View style={styles.scanInfo}>
        <Text style={styles.scanSpecies}>{item.species}</Text>
        <Text style={styles.scanDate}>{item.date}</Text>
      </View>
    </TouchableOpacity>
  );

  const renderBadgeItem = ({ item }) => (
    <View style={styles.badgeItem}>
      <MaterialCommunityIcons name={item.icon} size={32} color="#2196F3" />
      <Text style={styles.badgeTitle}>{item.title}</Text>
      <Text style={styles.badgeDescription}>{item.description}</Text>
    </View>
  );

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <View style={styles.profileInfo}>
          <View style={styles.avatarContainer}>
            <Ionicons name="person-circle" size={80} color="#2196F3" />
          </View>
          <Text style={styles.userName}>{mockUserData.name}</Text>
        </View>

        <View style={styles.statsContainer}>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>{mockUserData.scans}</Text>
            <Text style={styles.statLabel}>Total Scans</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>{mockUserData.accuracy}%</Text>
            <Text style={styles.statLabel}>Accuracy</Text>
          </View>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Recent Scans</Text>
        <FlatList
          data={mockUserData.savedScans}
          renderItem={renderScanItem}
          keyExtractor={(item) => item.id}
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.scansContainer}
        />
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Achievements</Text>
        <View style={styles.badgesContainer}>
          {mockUserData.badges.map((badge) => (
            <View key={badge.id} style={styles.badgeItem}>
              <MaterialCommunityIcons name={badge.icon} size={32} color="#2196F3" />
              <Text style={styles.badgeTitle}>{badge.title}</Text>
              <Text style={styles.badgeDescription}>{badge.description}</Text>
            </View>
          ))}
        </View>
      </View>

      <TouchableOpacity style={styles.premiumButton}>
        <Text style={styles.premiumButtonText}>Upgrade to Premium</Text>
        <Text style={styles.premiumButtonSubtext}>Get unlimited scans and AR features</Text>
      </TouchableOpacity>
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
    backgroundColor: '#f5f5f5',
  },
  profileInfo: {
    alignItems: 'center',
    marginBottom: 20,
  },
  avatarContainer: {
    marginBottom: 10,
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  statsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 15,
    elevation: 2,
  },
  statItem: {
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#2196F3',
  },
  statLabel: {
    fontSize: 14,
    color: '#666',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  scansContainer: {
    paddingRight: 20,
  },
  scanItem: {
    width: 160,
    marginRight: 15,
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
    overflow: 'hidden',
  },
  scanImage: {
    width: '100%',
    height: 120,
  },
  scanInfo: {
    padding: 10,
  },
  scanSpecies: {
    fontSize: 16,
    fontWeight: '500',
  },
  scanDate: {
    fontSize: 14,
    color: '#666',
  },
  badgesContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  badgeItem: {
    width: '48%',
    backgroundColor: '#f5f5f5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 15,
    alignItems: 'center',
  },
  badgeTitle: {
    fontSize: 16,
    fontWeight: '500',
    marginVertical: 5,
  },
  badgeDescription: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
  },
  premiumButton: {
    margin: 20,
    backgroundColor: '#FFD700',
    padding: 20,
    borderRadius: 10,
    alignItems: 'center',
  },
  premiumButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#000',
  },
  premiumButtonSubtext: {
    fontSize: 14,
    color: '#666',
    marginTop: 5,
  },
}); 