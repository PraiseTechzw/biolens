import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  useColorScheme,
} from 'react-native';
import { useRouter, Link } from 'expo-router';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function SignInScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';

  const handleSignIn = async () => {
    if (!email || !password) {
      // Show error message
      return;
    }

    setIsLoading(true);
    try {
      // Here you would typically make an API call to authenticate
      // For demo purposes, we'll just simulate a successful login
      await new Promise(resolve => setTimeout(resolve, 1000));
      await AsyncStorage.setItem('isAuthenticated', 'true');
      router.replace('/(tabs)');
    } catch (error) {
      console.error('Sign in error:', error);
      // Show error message
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={[
        styles.container,
        { backgroundColor: isDark ? '#121212' : '#fff' }
      ]}
    >
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.header}>
          <MaterialCommunityIcons
            name="leaf"
            size={60}
            color="#2E7D32"
          />
          <Text style={[
            styles.title,
            { color: isDark ? '#fff' : '#000' }
          ]}>Welcome Back</Text>
          <Text style={[
            styles.subtitle,
            { color: isDark ? '#aaa' : '#666' }
          ]}>Sign in to continue exploring nature</Text>
        </View>

        <View style={styles.form}>
          <View style={[
            styles.inputContainer,
            { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
          ]}>
            <MaterialCommunityIcons
              name="email-outline"
              size={20}
              color={isDark ? '#aaa' : '#666'}
            />
            <TextInput
              style={[
                styles.input,
                { color: isDark ? '#fff' : '#000' }
              ]}
              placeholder="Email"
              placeholderTextColor={isDark ? '#aaa' : '#666'}
              value={email}
              onChangeText={setEmail}
              autoCapitalize="none"
              keyboardType="email-address"
            />
          </View>

          <View style={[
            styles.inputContainer,
            { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
          ]}>
            <MaterialCommunityIcons
              name="lock-outline"
              size={20}
              color={isDark ? '#aaa' : '#666'}
            />
            <TextInput
              style={[
                styles.input,
                { color: isDark ? '#fff' : '#000' }
              ]}
              placeholder="Password"
              placeholderTextColor={isDark ? '#aaa' : '#666'}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
            />
            <TouchableOpacity
              onPress={() => setShowPassword(!showPassword)}
              style={styles.eyeIcon}
            >
              <MaterialCommunityIcons
                name={showPassword ? 'eye-off' : 'eye'}
                size={20}
                color={isDark ? '#aaa' : '#666'}
              />
            </TouchableOpacity>
          </View>

          <Link href="/auth/forgot-password" asChild>
            <TouchableOpacity>
              <Text style={styles.forgotPassword}>Forgot Password?</Text>
            </TouchableOpacity>
          </Link>

          <TouchableOpacity
            style={[
              styles.button,
              isLoading && styles.buttonDisabled
            ]}
            onPress={handleSignIn}
            disabled={isLoading}
          >
            <Text style={styles.buttonText}>
              {isLoading ? 'Signing in...' : 'Sign In'}
            </Text>
          </TouchableOpacity>

          <View style={styles.divider}>
            <View style={[
              styles.dividerLine,
              { backgroundColor: isDark ? '#333' : '#E0E0E0' }
            ]} />
            <Text style={[
              styles.dividerText,
              { color: isDark ? '#aaa' : '#666' }
            ]}>or continue with</Text>
            <View style={[
              styles.dividerLine,
              { backgroundColor: isDark ? '#333' : '#E0E0E0' }
            ]} />
          </View>

          <View style={styles.socialButtons}>
            <TouchableOpacity
              style={[
                styles.socialButton,
                { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
              ]}
            >
              <MaterialCommunityIcons name="google" size={24} color="#DB4437" />
            </TouchableOpacity>
            <TouchableOpacity
              style={[
                styles.socialButton,
                { backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5' }
              ]}
            >
              <MaterialCommunityIcons name="apple" size={24} color={isDark ? '#fff' : '#000'} />
            </TouchableOpacity>
          </View>
        </View>

        <View style={styles.footer}>
          <Text style={[
            styles.footerText,
            { color: isDark ? '#aaa' : '#666' }
          ]}>Don't have an account?</Text>
          <Link href="/auth/sign-up" asChild>
            <TouchableOpacity>
              <Text style={styles.footerLink}>Sign Up</Text>
            </TouchableOpacity>
          </Link>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    padding: 20,
  },
  header: {
    alignItems: 'center',
    marginTop: 60,
    marginBottom: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    marginTop: 20,
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
  },
  form: {
    marginBottom: 20,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 12,
    paddingHorizontal: 16,
    marginBottom: 16,
    height: 56,
  },
  input: {
    flex: 1,
    marginLeft: 12,
    fontSize: 16,
  },
  eyeIcon: {
    padding: 4,
  },
  forgotPassword: {
    color: '#2E7D32',
    fontSize: 14,
    textAlign: 'right',
    marginBottom: 20,
  },
  button: {
    backgroundColor: '#2E7D32',
    borderRadius: 12,
    height: 56,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  buttonDisabled: {
    opacity: 0.7,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  dividerLine: {
    flex: 1,
    height: 1,
  },
  dividerText: {
    marginHorizontal: 10,
    fontSize: 14,
  },
  socialButtons: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 20,
  },
  socialButton: {
    width: 56,
    height: 56,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 'auto',
    paddingVertical: 20,
    gap: 4,
  },
  footerText: {
    fontSize: 14,
  },
  footerLink: {
    color: '#2E7D32',
    fontSize: 14,
    fontWeight: '600',
  },
}); 