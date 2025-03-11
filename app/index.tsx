import { useEffect } from 'react';
import { View, Image, StyleSheet, Animated } from 'react-native';
import { useRouter } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function SplashScreen() {
  const router = useRouter();
  const fadeAnim = new Animated.Value(0);

  useEffect(() => {
    Animated.sequence([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 1000,
        useNativeDriver: true,
      }),
      Animated.delay(1000),
      Animated.timing(fadeAnim, {
        toValue: 0,
        duration: 500,
        useNativeDriver: true,
      }),
    ]).start();

    checkFirstTime();
  }, []);

  const checkFirstTime = async () => {
    try {
      const hasLaunched = await AsyncStorage.getItem('hasLaunched');
      const isAuthenticated = await AsyncStorage.getItem('isAuthenticated');

      setTimeout(() => {
        if (!hasLaunched) {
          router.replace('/onboarding');
        } else if (!isAuthenticated) {
          router.replace('/auth/sign-up');
        } else {
          router.replace('/(tabs)');
        }
      }, 2500);
    } catch (error) {
      console.error('Error checking first launch:', error);
      router.replace('/auth/sign-up');
    }
  };

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.logoContainer, { opacity: fadeAnim }]}>
        <Image
          source={require('../assets/images/logo.png')}
          style={styles.logo}
          resizeMode="contain"
        />
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#2E7D32',
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoContainer: {
    alignItems: 'center',
  },
  logo: {
    width: 200,
    height: 200,
  },
}); 