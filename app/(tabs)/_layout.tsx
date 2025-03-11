import { Tabs } from 'expo-router';
import { MaterialCommunityIcons, Ionicons } from '@expo/vector-icons';
import { View } from 'react-native';

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: '#2196F3',
        tabBarInactiveTintColor: '#666',
        tabBarStyle: {
          backgroundColor: '#fff',
          borderTopColor: '#eee',
          height: 60,
          paddingBottom: 8,
          paddingTop: 8,
          elevation: 8,
          shadowColor: '#000',
          shadowOffset: { width: 0, height: -2 },
          shadowOpacity: 0.1,
          shadowRadius: 4,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '500',
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
          tabBarIcon: ({ color, size, focused }) => (
            <View style={{ 
              alignItems: 'center',
              justifyContent: 'center',
              borderTopWidth: focused ? 2 : 0,
              borderTopColor: color,
              paddingTop: 2,
            }}>
              <MaterialCommunityIcons 
                name={focused ? "camera" : "camera-outline"} 
                size={size} 
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
          tabBarIcon: ({ color, size, focused }) => (
            <View style={{ 
              alignItems: 'center',
              justifyContent: 'center',
              borderTopWidth: focused ? 2 : 0,
              borderTopColor: color,
              paddingTop: 2,
            }}>
              <MaterialCommunityIcons 
                name={focused ? "book-open-page-variant" : "book-open-variant"} 
                size={size} 
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
          tabBarIcon: ({ color, size, focused }) => (
            <View style={{ 
              alignItems: 'center',
              justifyContent: 'center',
              borderTopWidth: focused ? 2 : 0,
              borderTopColor: color,
              paddingTop: 2,
            }}>
              <Ionicons 
                name={focused ? "school" : "school-outline"} 
                size={size} 
                color={color} 
              />
            </View>
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: 'Settings',
          tabBarIcon: ({ color, size, focused }) => (
            <View style={{ 
              alignItems: 'center',
              justifyContent: 'center',
              borderTopWidth: focused ? 2 : 0,
              borderTopColor: color,
              paddingTop: 2,
            }}>
              <Ionicons 
                name={focused ? "settings" : "settings-outline"} 
                size={size} 
                color={color} 
              />
            </View>
          ),
        }}
      />
    </Tabs>
  );
}
