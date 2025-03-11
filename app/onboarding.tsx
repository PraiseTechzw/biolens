import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  useWindowDimensions,
  TouchableOpacity,
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
    icon: 'leaf',
    color: '#4CAF50',
  },
  {
    id: '2',
    title: 'Instant Species Recognition',
    description: 'Point your camera at any plant or animal to instantly identify it.',
    icon: 'camera',
    color: '#2196F3',
  },
  {
    id: '3',
    title: 'Learn & Explore',
    description: 'Access detailed information, fun facts, and conservation status.',
    icon: 'book-open-variant',
    color: '#FF9800',
  },
];

export default function OnboardingScreen() {
  const { width } = useWindowDimensions();
  const [currentIndex, setCurrentIndex] = useState(0);
  const flatListRef = useRef(null);
  const router = useRouter();
  const scrollX = useRef(new Animated.Value(0)).current;

  const viewableItemsChanged = useRef(({ viewableItems }: { viewableItems: Array<{ index: number }> }) => {
    if (viewableItems[0]) {
      setCurrentIndex(viewableItems[0].index);
    }
  }).current;

  const viewConfig = useRef({ viewAreaCoveragePercentThreshold: 50 }).current;

  const handleComplete = async () => {
    try {
      await AsyncStorage.setItem('hasLaunched', 'true');
      router.replace('/');
    } catch (error) {
      console.error('Error saving first launch:', error);
    }
  };
  // Generate visual for first slide - Nature theme
  const NatureVisual = ({ color }: { color: string }) => (
    <View style={styles.visualContainer}>
      <View style={[styles.circle, { backgroundColor: `${color}20` }]}>
        <View style={[styles.innerCircle, { backgroundColor: `${color}40` }]}>
          <MaterialCommunityIcons name="leaf" size={80} color={color} />
        </View>
      </View>
      <View style={styles.decorationContainer}>
        {[...Array(5)].map((_, i) => (
          <View 
            key={i} 
            style={[
              styles.leafDecoration, 
              { 
                transform: [{ rotate: `${i * 72}deg` }],
                backgroundColor: `${color}${20 + i * 10}`,
                top: 20 + i * 15,
                left: i % 2 === 0 ? -100 - i * 10 : 100 + i * 10,
              }
            ]} 
          />
        ))}
      </View>
    </View>
  );
  // Generate visual for second slide - Camera recognition
  const CameraVisual = ({ color }: { color: string }) => (
    <View style={styles.visualContainer}>
      <View style={[styles.cameraBody, { backgroundColor: `${color}30` }]}>
        <View style={[styles.cameraLens, { borderColor: color }]}>
          <View style={[styles.innerLens, { backgroundColor: `${color}20` }]}>
            <View style={[styles.lensReflection, { backgroundColor: `${color}60` }]} />
          </View>
        </View>
        <View style={[styles.cameraButton, { backgroundColor: color }]} />
        <View style={styles.scanLines}>
          {[...Array(8)].map((_, i) => (
            <Animated.View 
              key={i} 
              style={[
                styles.scanLine, 
                { 
                  backgroundColor: `${color}${40 + i * 5}`,
                  top: 10 + i * 20,
                  width: '80%',
                  opacity: 0.7 - i * 0.08
                }
              ]} 
            />
          ))}
        </View>
      </View>
    </View>
  );

  // Generate visual for third slide - Learning/Information
  const LearningVisual = ({ color }: { color: string }) => (
    <View style={styles.visualContainer}>
      <View style={[styles.bookContainer, { backgroundColor: `${color}10` }]}>
        <View style={[styles.bookCover, { backgroundColor: color }]}>
          <MaterialCommunityIcons name="book-open-variant" size={50} color="white" />
        </View>
        <View style={styles.bookPages}>
          {[...Array(5)].map((_, i) => (
            <View 
              key={i} 
              style={[
                styles.bookPage, 
                { 
                  backgroundColor: '#fff',
                  right: i * 5,
                  height: 180 - i * 5,
                  transform: [{ rotate: `${i * 2}deg` }]
                }
              ]} 
            />
          ))}
        </View>
        <View style={styles.infoElements}>
          {[...Array(3)].map((_, i) => (
            <View key={i} style={styles.infoRow}>
              <View style={[styles.infoIcon, { backgroundColor: `${color}${50 + i * 10}` }]} />
              <View style={[styles.infoLine, { backgroundColor: `${color}${30 + i * 10}` }]} />
            </View>
          ))}
        </View>
      </View>
    </View>
  );

  type OnboardingItem = {
    id: string;
    title: string;
    description: string;
    icon: string;
    color: string;
  };

  const renderItem = ({ item, index }: { item: OnboardingItem; index: number }) => {
    const inputRange = [
      (index - 1) * width,
      index * width,
      (index + 1) * width,
    ];

    const scale = scrollX.interpolate({
      inputRange,
      outputRange: [0.8, 1, 0.8],
    });

    let Visual;
    if (index === 0) {
      Visual = NatureVisual;
    } else if (index === 1) {
      Visual = CameraVisual;
    } else {
      Visual = LearningVisual;
    }

    return (
      <View style={[styles.slide, { width }]}>
        <Animated.View style={[styles.visualWrapper, { transform: [{ scale }] }]}>
          <Visual color={item.color} />
        </Animated.View>
        <View style={styles.iconContainer}>
          <MaterialCommunityIcons name={item.icon as any} size={40} color={item.color} />
        </View>
        <Text style={[styles.title, { color: item.color }]}>{item.title}</Text>
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
        onViewableItemsChanged={(info) => {
          const { viewableItems } = info;
          if (viewableItems.length > 0 && viewableItems[0].index !== null) {
            setCurrentIndex(viewableItems[0].index);
          }
        }}
        viewabilityConfig={viewConfig}
      />

      <View style={styles.footer}>
        <View style={styles.pagination}>
          {onboardingData.map((item, index) => {
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
                  { width: dotWidth, opacity, backgroundColor: item.color },
                  currentIndex === index && styles.dotActive,
                ]}
              />
            );
          })}
        </View>

        <TouchableOpacity
          style={[styles.button, { backgroundColor: onboardingData[currentIndex].color }]}
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
  visualWrapper: {
    height: 300,
    width: 300,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  visualContainer: {
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  // Nature visual styles
  circle: {
    width: 200,
    height: 200,
    borderRadius: 100,
    justifyContent: 'center',
    alignItems: 'center',
  },
  innerCircle: {
    width: 150,
    height: 150,
    borderRadius: 75,
    justifyContent: 'center',
    alignItems: 'center',
  },
  decorationContainer: {
    position: 'absolute',
    width: '100%',
    height: '100%',
  },
  leafDecoration: {
    position: 'absolute',
    width: 40,
    height: 80,
    borderRadius: 20,
  },
  // Camera visual styles
  cameraBody: {
    width: 220,
    height: 180,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  cameraLens: {
    width: 100,
    height: 100,
    borderRadius: 50,
    borderWidth: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  innerLens: {
    width: 70,
    height: 70,
    borderRadius: 35,
    justifyContent: 'center',
    alignItems: 'center',
  },
  lensReflection: {
    position: 'absolute',
    width: 20,
    height: 20,
    borderRadius: 10,
    top: 10,
    right: 10,
  },
  cameraButton: {
    position: 'absolute',
    width: 20,
    height: 20,
    borderRadius: 10,
    top: 20,
    right: 30,
  },
  scanLines: {
    position: 'absolute',
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanLine: {
    position: 'absolute',
    height: 2,
    borderRadius: 1,
  },
  // Learning visual styles
  bookContainer: {
    width: 220,
    height: 220,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  bookCover: {
    position: 'absolute',
    width: 120,
    height: 180,
    borderRadius: 10,
    left: 40,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 10,
  },
  bookPages: {
    position: 'absolute',
    left: 40,
    zIndex: 5,
  },
  bookPage: {
    position: 'absolute',
    width: 120,
    borderRadius: 5,
  },
  infoElements: {
    position: 'absolute',
    right: 30,
    top: 60,
    width: 100,
    height: 100,
    justifyContent: 'space-around',
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  infoIcon: {
    width: 20,
    height: 20,
    borderRadius: 10,
    marginRight: 10,
  },
  infoLine: {
    height: 8,
    width: 60,
    borderRadius: 4,
  },
  iconContainer: {
    width: 80,
    height: 80,
    backgroundColor: 'rgba(0, 0, 0, 0.05)',
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
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
    marginHorizontal: 4,
  },
  dotActive: {
    backgroundColor: '#2E7D32',
  },
  button: {
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