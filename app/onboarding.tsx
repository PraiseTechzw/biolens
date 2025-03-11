import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  useWindowDimensions,
  TouchableOpacity,
  Image,
  Animated,
} from 'react-native';
import { useRouter } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { MaterialCommunityIcons } from '@expo/vector-icons';

const onboardingData = [
  {
    id: '1',
    title: 'Welcome to BioLens',
    description: 'Your AI-powered companion for exploring and learning about nature.',
    image: require('../assets/images/onboarding-1.png'),
    icon: 'leaf',
  },
  {
    id: '2',
    title: 'Instant Species Recognition',
    description: 'Point your camera at any plant or animal to instantly identify it.',
    image: require('../assets/images/onboarding-2.png'),
    icon: 'camera',
  },
  {
    id: '3',
    title: 'Learn & Explore',
    description: 'Access detailed information, fun facts, and conservation status.',
    image: require('../assets/images/onboarding-3.png'),
    icon: 'book-open-variant',
  },
];

export default function OnboardingScreen() {
  const { width } = useWindowDimensions();
  const [currentIndex, setCurrentIndex] = useState(0);
  const flatListRef = useRef(null);
  const router = useRouter();
  const scrollX = useRef(new Animated.Value(0)).current;

  const viewableItemsChanged = useRef(({ viewableItems }) => {
    if (viewableItems[0]) {
      setCurrentIndex(viewableItems[0].index);
    }
  }).current;

  const viewConfig = useRef({ viewAreaCoveragePercentThreshold: 50 }).current;

  const handleComplete = async () => {
    try {
      await AsyncStorage.setItem('hasLaunched', 'true');
      router.replace('/auth');
    } catch (error) {
      console.error('Error saving first launch:', error);
    }
  };

  const renderItem = ({ item, index }) => {
    const inputRange = [
      (index - 1) * width,
      index * width,
      (index + 1) * width,
    ];

    const scale = scrollX.interpolate({
      inputRange,
      outputRange: [0.8, 1, 0.8],
    });

    return (
      <View style={[styles.slide, { width }]}>
        <Animated.View style={[styles.imageContainer, { transform: [{ scale }] }]}>
          <Image source={item.image} style={styles.image} resizeMode="contain" />
        </Animated.View>
        <View style={styles.iconContainer}>
          <MaterialCommunityIcons name={item.icon} size={40} color="#2E7D32" />
        </View>
        <Text style={styles.title}>{item.title}</Text>
        <Text style={styles.description}>{item.description}</Text>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <FlatList
        ref={flatListRef}
        data={onboardingData}
        renderItem={renderItem}
        horizontal
        showsHorizontalScrollIndicator={false}
        pagingEnabled
        bounces={false}
        keyExtractor={(item) => item.id}
        onScroll={Animated.event(
          [{ nativeEvent: { contentOffset: { x: scrollX } } }],
          { useNativeDriver: false }
        )}
        onViewableItemsChanged={viewableItemsChanged}
        viewabilityConfig={viewConfig}
      />

      <View style={styles.footer}>
        <View style={styles.pagination}>
          {onboardingData.map((_, index) => {
            const inputRange = [(index - 1) * width, index * width, (index + 1) * width];
            const dotWidth = scrollX.interpolate({
              inputRange,
              outputRange: [8, 16, 8],
              extrapolate: 'clamp',
            });
            const opacity = scrollX.interpolate({
              inputRange,
              outputRange: [0.3, 1, 0.3],
              extrapolate: 'clamp',
            });

            return (
              <Animated.View
                key={index.toString()}
                style={[
                  styles.dot,
                  { width: dotWidth, opacity },
                  currentIndex === index && styles.dotActive,
                ]}
              />
            );
          })}
        </View>

        <TouchableOpacity
          style={styles.button}
          onPress={handleComplete}
        >
          <Text style={styles.buttonText}>
            {currentIndex === onboardingData.length - 1 ? 'Get Started' : 'Skip'}
          </Text>
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
  slide: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  imageContainer: {
    flex: 0.7,
    justifyContent: 'center',
  },
  image: {
    width: 300,
    height: 300,
  },
  iconContainer: {
    width: 80,
    height: 80,
    backgroundColor: 'rgba(46, 125, 50, 0.1)',
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#2E7D32',
    textAlign: 'center',
    marginBottom: 10,
  },
  description: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    paddingHorizontal: 20,
  },
  footer: {
    padding: 20,
  },
  pagination: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginBottom: 20,
  },
  dot: {
    height: 8,
    borderRadius: 4,
    backgroundColor: '#2E7D32',
    marginHorizontal: 4,
  },
  dotActive: {
    backgroundColor: '#2E7D32',
  },
  button: {
    backgroundColor: '#2E7D32',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
}); 