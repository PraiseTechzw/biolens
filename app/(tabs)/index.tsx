import React, { useState, useEffect } from 'react';
import { StyleSheet, View, TouchableOpacity, Text, ActivityIndicator } from 'react-native';
import { Camera } from 'expo-camera';
import { MaterialIcons, Ionicons } from '@expo/vector-icons';
import { Link } from 'expo-router';

export default function HomeScreen() {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [camera, setCamera] = useState<Camera | null>(null);
  const [isScanning, setIsScanning] = useState(false);
  const [confidence, setConfidence] = useState(0);

  useEffect(() => {
    (async () => {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasPermission(status === 'granted');
    })();
  }, []);

  const handleCapture = async () => {
    if (!camera) return;
    setIsScanning(true);
    // Simulate AI processing
    setTimeout(() => {
      setIsScanning(false);
      setConfidence(95);
      // Navigate to results screen
    }, 2000);
  };

  if (hasPermission === null) {
    return <View />;
  }
  if (hasPermission === false) {
    return <Text>No access to camera</Text>;
  }

  return (
    <View style={styles.container}>
      <Camera
        style={styles.camera}
        ref={(ref) => setCamera(ref)}
        type={Camera.Constants.Type.back}
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
      </Camera>
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
