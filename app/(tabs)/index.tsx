import React, { useState, useRef, useEffect } from 'react';
import { 
  StyleSheet, 
  View, 
  TouchableOpacity, 
  Text, 
  ActivityIndicator,
  Animated,
  Dimensions,
  Platform,
} from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';
import { MaterialIcons, Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';

const { width, height } = Dimensions.get('window');
type CameraViewType = React.ElementRef<typeof CameraView>;

interface CameraMode {
  id: string;
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  label: string;
}

export default function HomeScreen() {
  const [permission, requestPermission] = useCameraPermissions();
  const [isScanning, setIsScanning] = useState(false);
  const [confidence, setConfidence] = useState(0);
  const [isFrontCamera, setIsFrontCamera] = useState(false);
  const [selectedMode, setSelectedMode] = useState<'auto' | 'manual'>('auto');
  const cameraRef = useRef<CameraViewType>(null);
  const router = useRouter();
  const scanAnimation = useRef(new Animated.Value(0)).current;

  const cameraModes: CameraMode[] = [
    { id: 'auto', icon: 'auto-fix', label: 'Auto ID' },
    { id: 'manual', icon: 'cursor-pointer', label: 'Manual' },
  ];

  useEffect(() => {
    if (isScanning) {
      Animated.loop(
        Animated.sequence([
          Animated.timing(scanAnimation, {
            toValue: 1,
            duration: 1500,
            useNativeDriver: true,
          }),
          Animated.timing(scanAnimation, {
            toValue: 0,
            duration: 1500,
            useNativeDriver: true,
          }),
        ])
      ).start();
    } else {
      scanAnimation.setValue(0);
    }
  }, [isScanning]);

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <View style={styles.permissionContainer}>
        <MaterialCommunityIcons name="camera-off" size={64} color="#666" />
        <Text style={styles.permissionTitle}>Camera Access Required</Text>
        <Text style={styles.permissionText}>
          BioLens needs camera access to help you identify species in real-time.
        </Text>
        <TouchableOpacity style={styles.permissionButton} onPress={requestPermission}>
          <Text style={styles.permissionButtonText}>Grant Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const handleCapture = async () => {
    if (!cameraRef.current) return;
    
    setIsScanning(true);
    try {
      const photo = await cameraRef.current.takePictureAsync({
        quality: 1,
        base64: true,
      });

      if (!photo) {
        throw new Error('Failed to take picture');
      }

      // In a real app, you would send the photo.base64 to your AI service
      // For now, we'll simulate processing
      setTimeout(() => {
        setIsScanning(false);
        setConfidence(95);
        router.push({
          pathname: '/scan-results',
          params: {
            imageUri: photo.uri,
            species: 'Red-tailed Hawk',
            confidence: '95',
          }
        });
      }, 2000);
    } catch (error) {
      console.error('Error taking picture:', error);
      setIsScanning(false);
    }
  };

  const toggleCameraType = () => {
    setIsFrontCamera(prev => !prev);
  };

  return (
    <View style={styles.container}>
      <CameraView
        ref={cameraRef}
        style={styles.camera}
        facing={isFrontCamera ? 'front' : 'back'}
        onMountError={(error) => console.error('Camera mount error:', error)}
      >
        <View style={styles.header}>
          <View style={styles.headerLeft}>
            <Link href="/settings" asChild>
              <TouchableOpacity style={styles.headerButton}>
                <Ionicons name="settings-outline" size={24} color="white" />
              </TouchableOpacity>
            </Link>
          </View>

          <View style={styles.modeSelector}>
            {cameraModes.map((mode) => (
              <TouchableOpacity
                key={mode.id}
                style={[
                  styles.modeButton,
                  selectedMode === mode.id && styles.modeButtonActive
                ]}
                onPress={() => setSelectedMode(mode.id as 'auto' | 'manual')}
              >
                <MaterialCommunityIcons
                  name={mode.icon}
                  size={20}
                  color={selectedMode === mode.id ? '#00796B' : '#fff'}
                />
                <Text style={[
                  styles.modeButtonText,
                  selectedMode === mode.id && styles.modeButtonTextActive
                ]}>
                  {mode.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <View style={styles.headerRight}>
            <Link href="/profile" asChild>
              <TouchableOpacity style={styles.headerButton}>
                <MaterialIcons name="account-circle" size={24} color="white" />
              </TouchableOpacity>
            </Link>
          </View>
        </View>

        <Animated.View
          style={[
            styles.scanFrame,
            {
              transform: [{
                scale: scanAnimation.interpolate({
                  inputRange: [0, 1],
                  outputRange: [0.95, 1.05]
                })
              }]
            }
          ]}
        >
          {isScanning && (
            <View style={styles.scanningOverlay}>
              <ActivityIndicator size="large" color="#ffffff" />
              <Text style={styles.scanningText}>Analyzing Species...</Text>
              <Text style={styles.scanningSubtext}>Hold steady for best results</Text>
            </View>
          )}
        </Animated.View>

        <View style={styles.footer}>
          <TouchableOpacity style={styles.controlButton}>
            <MaterialCommunityIcons name="image-multiple" size={24} color="white" />
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.captureButton, isScanning && styles.captureButtonDisabled]}
            onPress={handleCapture}
            disabled={isScanning}
          >
            <View style={styles.captureButtonInner}>
              {isScanning && <ActivityIndicator size="small" color="#00796B" />}
            </View>
          </TouchableOpacity>

          <TouchableOpacity style={styles.controlButton} onPress={toggleCameraType}>
            <Ionicons name="camera-reverse" size={24} color="white" />
          </TouchableOpacity>
        </View>

        {!isScanning && (
          <View style={styles.tips}>
            <MaterialCommunityIcons name="lightbulb-outline" size={20} color="white" />
            <Text style={styles.tipsText}>
              Center the species in the frame for best identification
            </Text>
          </View>
        )}
      </CameraView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  camera: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    paddingTop: Platform.OS === 'ios' ? 60 : 40,
  },
  headerLeft: {
    flex: 1,
  },
  headerRight: {
    flex: 1,
    alignItems: 'flex-end',
  },
  headerButton: {
    padding: 8,
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius: 20,
  },
  modeSelector: {
    flexDirection: 'row',
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius: 20,
    padding: 4,
  },
  modeButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 16,
  },
  modeButtonActive: {
    backgroundColor: '#fff',
  },
  modeButtonText: {
    color: '#fff',
    fontSize: 14,
    marginLeft: 4,
  },
  modeButtonTextActive: {
    color: '#00796B',
    fontWeight: '600',
  },
  scanFrame: {
    flex: 1,
    margin: 40,
    borderWidth: 2,
    borderColor: 'rgba(255,255,255,0.5)',
    borderRadius: 20,
    overflow: 'hidden',
  },
  scanningOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.6)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanningText: {
    color: 'white',
    fontSize: 18,
    fontWeight: '600',
    marginTop: 12,
  },
  scanningSubtext: {
    color: 'rgba(255,255,255,0.8)',
    fontSize: 14,
    marginTop: 8,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    paddingBottom: Platform.OS === 'ios' ? 40 : 20,
    paddingHorizontal: 30,
  },
  controlButton: {
    width: 44,
    height: 44,
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButton: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: 'rgba(255,255,255,0.3)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButtonDisabled: {
    opacity: 0.7,
  },
  captureButtonInner: {
    width: 70,
    height: 70,
    borderRadius: 35,
    backgroundColor: 'white',
    justifyContent: 'center',
    alignItems: 'center',
  },
  tips: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 20,
    position: 'absolute',
    bottom: Platform.OS === 'ios' ? 100 : 80,
    left: 20,
    right: 20,
  },
  tipsText: {
    color: 'white',
    fontSize: 14,
    marginLeft: 8,
  },
  permissionContainer: {
    flex: 1,
    backgroundColor: '#fff',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  permissionTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginTop: 20,
    marginBottom: 10,
  },
  permissionText: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 30,
  },
  permissionButton: {
    backgroundColor: '#00796B',
    paddingHorizontal: 30,
    paddingVertical: 15,
    borderRadius: 12,
  },
  permissionButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
});
