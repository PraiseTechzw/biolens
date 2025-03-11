import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
  useColorScheme,
  Switch,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface UserStats {
  speciesIdentified: number;
  contributions: number;
  accuracy: number;
  streak: number;
}

interface Achievement {
  id: number;
  title: string;
  description: string;
  icon: string;
  date: string;
}

const userStats: UserStats = {
  speciesIdentified: 127,
  contributions: 45,
  accuracy: 92,
  streak: 7,
};

const recentAchievements: Achievement[] = [
  {
    id: 1,
    title: "Early Bird",
    description: "Complete 5 identifications before 9 AM",
    icon: "weather-sunny",
    date: "2024-03-10",
  },
  {
    id: 2,
    title: "Tree Expert",
    description: "Successfully identify 50 different tree species",
    icon: "tree",
    date: "2024-03-08",
  },
];

const settingsOptions = [
  {
    id: 'notifications',
    title: 'Push Notifications',
    icon: 'bell-outline',
    type: 'toggle',
  },
  {
    id: 'darkMode',
    title: 'Dark Mode',
    icon: 'theme-light-dark',
    type: 'toggle',
  },
  {
    id: 'language',
    title: 'Language',
    icon: 'translate',
    type: 'navigate',
    value: 'English',
  },
  {
    id: 'units',
    title: 'Measurement Units',
    icon: 'ruler',
    type: 'navigate',
    value: 'Metric',
  },
  {
    id: 'privacy',
    title: 'Privacy Settings',
    icon: 'shield-check-outline',
    type: 'navigate',
  },
  {
    id: 'about',
    title: 'About BioLens',
    icon: 'information-outline',
    type: 'navigate',
  },
];

export default function ProfileScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';

  const handleLogout = async () => {
    try {
      await AsyncStorage.removeItem('isAuthenticated');
      router.replace('/auth/sign-in');
    } catch (error) {
      console.error('Error logging out:', error);
    }
  };

  return (
    <View style={[
      styles.container,
      { backgroundColor: isDark ? '#121212' : '#fff' }
    ]}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <View style={styles.profileInfo}>
            <Image
              source={{ uri: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde' }}
              style={styles.avatar}
            />
            <View>
              <Text style={[
                styles.name,
                { color: isDark ? '#fff' : '#000' }
              ]}>John Doe</Text>
              <Text style={styles.email}>john.doe@example.com</Text>
            </View>
          </View>
          <TouchableOpacity
            style={styles.editButton}
            onPress={() => router.push('/(tabs)/profile/edit')}
          >
            <MaterialCommunityIcons name="pencil" size={20} color="#2E7D32" />
          </TouchableOpacity>
        </View>

        <View style={styles.statsContainer}>
          <View style={styles.statCard}>
            <MaterialCommunityIcons name="leaf" size={24} color="#2E7D32" />
            <Text style={[
              styles.statNumber,
              { color: isDark ? '#fff' : '#000' }
            ]}>{userStats.speciesIdentified}</Text>
            <Text style={styles.statLabel}>Species{'\n'}Identified</Text>
          </View>
          <View style={styles.statCard}>
            <MaterialCommunityIcons name="database" size={24} color="#2E7D32" />
            <Text style={[
              styles.statNumber,
              { color: isDark ? '#fff' : '#000' }
            ]}>{userStats.contributions}</Text>
            <Text style={styles.statLabel}>Contributions{'\n'}Made</Text>
          </View>
          <View style={styles.statCard}>
            <MaterialCommunityIcons name="check-circle" size={24} color="#2E7D32" />
            <Text style={[
              styles.statNumber,
              { color: isDark ? '#fff' : '#000' }
            ]}>{userStats.accuracy}%</Text>
            <Text style={styles.statLabel}>Identification{'\n'}Accuracy</Text>
          </View>
          <View style={styles.statCard}>
            <MaterialCommunityIcons name="fire" size={24} color="#2E7D32" />
            <Text style={[
              styles.statNumber,
              { color: isDark ? '#fff' : '#000' }
            ]}>{userStats.streak}</Text>
            <Text style={styles.statLabel}>Day{'\n'}Streak</Text>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={[
            styles.sectionTitle,
            { color: isDark ? '#fff' : '#000' }
          ]}>Recent Achievements</Text>
          {recentAchievements.map(achievement => (
            <View
              key={achievement.id}
              style={[
                styles.achievementCard,
                { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
              ]}
            >
              <MaterialCommunityIcons
                name={achievement.icon as any}
                size={32}
                color="#2E7D32"
              />
              <View style={styles.achievementInfo}>
                <Text style={[
                  styles.achievementTitle,
                  { color: isDark ? '#fff' : '#000' }
                ]}>{achievement.title}</Text>
                <Text style={styles.achievementDescription}>{achievement.description}</Text>
                <Text style={styles.achievementDate}>
                  {new Date(achievement.date).toLocaleDateString()}
                </Text>
              </View>
            </View>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={[
            styles.sectionTitle,
            { color: isDark ? '#fff' : '#000' }
          ]}>Settings</Text>
          {settingsOptions.map(option => (
            <TouchableOpacity
              key={option.id}
              style={[
                styles.settingItem,
                { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
              ]}
              onPress={() => {
                if (option.type === 'navigate') {
                  router.push(`/(tabs)/profile/settings/${option.id}`);
                }
              }}
            >
              <View style={styles.settingInfo}>
                <MaterialCommunityIcons
                  name={option.icon as any}
                  size={24}
                  color="#2E7D32"
                />
                <Text style={[
                  styles.settingTitle,
                  { color: isDark ? '#fff' : '#000' }
                ]}>{option.title}</Text>
              </View>
              {option.type === 'toggle' ? (
                <Switch
                  value={false}
                  onValueChange={() => {}}
                  trackColor={{ false: '#767577', true: '#81c784' }}
                  thumbColor={false ? '#2E7D32' : '#f4f3f4'}
                />
              ) : (
                <View style={styles.settingAction}>
                  {option.value && (
                    <Text style={styles.settingValue}>{option.value}</Text>
                  )}
                  <MaterialCommunityIcons
                    name="chevron-right"
                    size={24}
                    color={isDark ? '#aaa' : '#666'}
                  />
                </View>
              )}
            </TouchableOpacity>
          ))}
        </View>

        <TouchableOpacity
          style={styles.logoutButton}
          onPress={handleLogout}
        >
          <MaterialCommunityIcons name="logout" size={24} color="#FF5252" />
          <Text style={styles.logoutText}>Log Out</Text>
        </TouchableOpacity>
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
    marginBottom: 24,
  },
  profileInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16,
  },
  avatar: {
    width: 64,
    height: 64,
    borderRadius: 32,
  },
  name: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 4,
  },
  email: {
    fontSize: 14,
    color: '#2E7D32',
  },
  editButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(46, 125, 50, 0.1)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  statsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 16,
    padding: 20,
  },
  statCard: {
    flex: 1,
    minWidth: '45%',
    backgroundColor: 'rgba(46, 125, 50, 0.1)',
    borderRadius: 16,
    padding: 16,
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    marginVertical: 8,
  },
  statLabel: {
    fontSize: 12,
    color: '#2E7D32',
    textAlign: 'center',
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
  achievementCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 20,
    marginBottom: 12,
    padding: 16,
    borderRadius: 16,
    gap: 16,
  },
  achievementInfo: {
    flex: 1,
  },
  achievementTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  achievementDescription: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  achievementDate: {
    fontSize: 12,
    color: '#2E7D32',
  },
  settingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginHorizontal: 20,
    marginBottom: 12,
    padding: 16,
    borderRadius: 16,
  },
  settingInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  settingTitle: {
    fontSize: 16,
    fontWeight: '500',
  },
  settingAction: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  settingValue: {
    fontSize: 14,
    color: '#666',
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    marginHorizontal: 20,
    marginVertical: 24,
    padding: 16,
    borderRadius: 16,
    backgroundColor: 'rgba(244, 67, 54, 0.1)',
  },
  logoutText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FF5252',
  },
}); 