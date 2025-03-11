import React, { useState, useRef } from 'react';
import { StyleSheet, View, TouchableOpacity, Text, ActivityIndicator } from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';
import { MaterialIcons, Ionicons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';

type CameraViewType = React.ElementRef<typeof CameraView>;

export default function HomeScreen() {
  const [permission, requestPermission] = useCameraPermissions();
  const [isScanning, setIsScanning] = useState(false);
  const [confidence, setConfidence] = useState(0);
  const cameraRef = useRef<CameraViewType>(null);
  const router = useRouter();

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <View style={styles.container}>
        <Text>No access to camera</Text>
        <TouchableOpacity onPress={requestPermission}>
          <Text>Grant Permission</Text>
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
            species: 'Red-tailed Hawk', // This would come from AI in real app
            confidence: 95,
          }
        });
      }, 2000);
    } catch (error) {
      console.error('Error taking picture:', error);
      setIsScanning(false);
    }
  };

  return (
    <View style={styles.container}>
      <CameraView
        ref={cameraRef}
        style={styles.camera}
        facing="back"
        onMountError={(error) => console.error('Camera mount error:', error)}
      >
        <View style={styles.header}>
          <Link href="/settings" asChild>
            <TouchableOpacity style={styles.headerButton}>
              <Ionicons name="settings-outline" size={24} color="white" />
            </TouchableOpacity>
          </Link>
          <Link href="/profile" asChild>
            <TouchableOpacity style={styles.headerButton}>
              <MaterialIcons name="account-circle" size={24} color="white" />
            </TouchableOpacity>
          </Link>
        </View>

        {isScanning && (
          <View style={styles.scanningOverlay}>
            <ActivityIndicator size="large" color="#ffffff" />
            <Text style={styles.scanningText}>Analyzing...</Text>
          </View>
        )}

        <View style={styles.boundingBox} />

        <View style={styles.footer}>
          <TouchableOpacity
            style={styles.captureButton}
            onPress={handleCapture}
            disabled={isScanning}
          >
            <View style={styles.captureButtonInner} />
          </TouchableOpacity>
        </View>
      </CameraView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  camera: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    padding: 20,
    paddingTop: 60,
  },
  headerButton: {
    marginLeft: 15,
  },
  scanningOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.6)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanningText: {
    color: 'white',
    marginTop: 10,
    fontSize: 16,
  },
  boundingBox: {
    flex: 1,
    margin: 40,
    borderWidth: 2,
    borderColor: 'rgba(255,255,255,0.5)',
    borderRadius: 10,
  },
  footer: {
    height: 100,
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButton: {
    width: 70,
    height: 70,
    borderRadius: 35,
    backgroundColor: 'rgba(255,255,255,0.3)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  captureButtonInner: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: 'white',
  },
});
