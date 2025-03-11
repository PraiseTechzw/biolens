import { Tabs } from 'expo-router';
import { Platform, View, useColorScheme } from 'react-native';
import { MaterialCommunityIcons, Ionicons } from '@expo/vector-icons';
import { BlurView } from 'expo-blur';

// Color constants for light and dark themes
const colors = {
  light: {
    primary: '#2E7D32', // Vibrant green
    secondary: '#1B5E20', // Dark green
    background: '#FFFFFF',
    tabBar: 'rgba(255,255,255,0.9)',
    active: '#2E7D32',
    inactive: '#757575',
    border: 'rgba(0,0,0,0.1)',
  },
  dark: {
    primary: '#4CAF50', // Bright green
    secondary: '#81C784', // Light green
    background: '#121212',
    tabBar: 'rgba(18,18,18,0.9)',
    active: '#4CAF50',
    inactive: '#9E9E9E',
    border: 'rgba(255,255,255,0.1)',
  },
};

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const theme = colors[colorScheme ?? 'light'];

  return (
    <Tabs
      screenOptions={{
        tabBarStyle: {
          height: Platform.OS === 'ios' ? 85 : 65,
          paddingBottom: Platform.OS === 'ios' ? 30 : 12,
          paddingTop: 12,
          backgroundColor: theme.tabBar,
          borderTopWidth: 0,
          elevation: 0,
          shadowColor: theme.background === '#FFFFFF' ? '#000' : '#fff',
          shadowOffset: {
            width: 0,
            height: -2,
          },
          shadowOpacity: theme.background === '#FFFFFF' ? 0.1 : 0.2,
          shadowRadius: 3,
        },
        tabBarActiveTintColor: theme.active,
        tabBarInactiveTintColor: theme.inactive,
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '600',
          marginTop: -4,
        },
        tabBarIconStyle: {
          marginBottom: -4,
        },
        headerShown: false,
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Scan',
          tabBarIcon: ({ focused, color }) => (
            <View style={{ alignItems: 'center' }}>
              <MaterialCommunityIcons
                name={focused ? 'camera' : 'camera-outline'}
                size={24}
                color={color}
              />
            </View>
          ),
        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: 'Explore',
          tabBarIcon: ({ focused, color }) => (
            <View style={{ alignItems: 'center' }}>
              <MaterialCommunityIcons
                name={focused ? 'compass' : 'compass-outline'}
                size={24}
                color={color}
              />
            </View>
          ),
        }}
      />
      <Tabs.Screen
        name="collection"
        options={{
          title: 'Collection',
          tabBarIcon: ({ focused, color }) => (
            <View style={{ alignItems: 'center' }}>
              <MaterialCommunityIcons
                name={focused ? 'flower' : 'flower-outline'}
                size={24}
                color={color}
              />
            </View>
          ),
        }}
      />
      <Tabs.Screen
        name="learn"
        options={{
          title: 'Learn',
          tabBarIcon: ({ focused, color }) => (
            <View style={{ alignItems: 'center' }}>
              <MaterialCommunityIcons
                name={focused ? 'book-open-variant' : 'book-open-outline'}
                size={24}
                color={color}
              />
            </View>
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Profile',
          tabBarIcon: ({ focused, color }) => (
            <View style={{ alignItems: 'center' }}>
              <MaterialCommunityIcons
                name={focused ? 'account-circle' : 'account-circle-outline'}
                size={24}
                color={color}
              />
            </View>
          ),
        }}
      />
    </Tabs>
  );
}
