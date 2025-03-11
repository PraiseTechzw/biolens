import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Image,
  TouchableOpacity,
  useColorScheme,
  Dimensions,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { MaterialCommunityIcons } from '@expo/vector-icons';

interface SpeciesDetails {
  id: number;
  name: string;
  scientificName: string;
  description: string;
  image: string;
  category: string;
  habitat: string;
  distribution: string;
  characteristics: string[];
  conservationStatus: {
    status: string;
    color: string;
  };
  funFacts: string[];
}

// Mock data - in a real app, this would come from an API
const speciesData: Record<string, SpeciesDetails> = {
  "1": {
    id: 1,
    name: "Giant Sequoia",
    scientificName: "Sequoiadendron giganteum",
    description: "The Giant Sequoia is one of the largest and longest-living tree species on Earth, capable of reaching heights over 300 feet.",
    image: "https://images.unsplash.com/photo-1503785640985-f62e3aeee448",
    category: "Trees",
    habitat: "Native to the western Sierra Nevada mountains of California",
    distribution: "Sierra Nevada, California, USA",
    characteristics: [
      "Can grow to heights of 300+ feet",
      "Trunk diameter can exceed 30 feet",
      "Bark can be up to 3 feet thick",
      "Can live for over 3,000 years",
    ],
    conservationStatus: {
      status: "Endangered",
      color: "#FF5252",
    },
    funFacts: [
      "The largest tree on Earth by volume is a Giant Sequoia",
      "Their bark contains natural fire-resistant chemicals",
      "They rely on forest fires to reproduce",
    ],
  },
  "2": {
    id: 2,
    name: "Venus Flytrap",
    scientificName: "Dionaea muscipula",
    description: "The Venus Flytrap is a carnivorous plant that catches prey using a trapping structure formed by the terminal portion of each leaf.",
    image: "https://images.unsplash.com/photo-1515689917361-d41c8e411ea8",
    category: "Plants",
    habitat: "Wet pine savannas",
    distribution: "Native to North and South Carolina",
    characteristics: [
      "Traps close in about half a second",
      "Each trap has sensitive trigger hairs",
      "Can only close a few times before the leaf dies",
      "Digestion takes 5-12 days",
    ],
    conservationStatus: {
      status: "Vulnerable",
      color: "#FFA726",
    },
    funFacts: [
      "They can count! They only close after two trigger hair stimulations",
      "They can grow up to 6 inches in diameter",
      "Charles Darwin called it 'the most wonderful plant in the world'",
    ],
  },
};

export default function SpeciesDetailsScreen() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [isFavorite, setIsFavorite] = useState(false);
  
  const species = speciesData[id as string];
  
  if (!species) {
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorText}>Species not found</Text>
      </View>
    );
  }

  return (
    <View style={[
      styles.container,
      { backgroundColor: isDark ? '#121212' : '#fff' }
    ]}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Image
          source={{ uri: species.image }}
          style={styles.image}
        />
        
        <View style={styles.header}>
          <TouchableOpacity
            style={[styles.backButton, { backgroundColor: isDark ? 'rgba(0,0,0,0.5)' : 'rgba(255,255,255,0.8)' }]}
            onPress={() => router.back()}
          >
            <MaterialCommunityIcons
              name="arrow-left"
              size={24}
              color={isDark ? '#fff' : '#000'}
            />
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.favoriteButton, { backgroundColor: isDark ? 'rgba(0,0,0,0.5)' : 'rgba(255,255,255,0.8)' }]}
            onPress={() => setIsFavorite(!isFavorite)}
          >
            <MaterialCommunityIcons
              name={isFavorite ? 'heart' : 'heart-outline'}
              size={24}
              color={isFavorite ? '#FF5252' : (isDark ? '#fff' : '#000')}
            />
          </TouchableOpacity>
        </View>

        <View style={styles.content}>
          <View style={styles.titleSection}>
            <View>
              <Text style={[
                styles.name,
                { color: isDark ? '#fff' : '#000' }
              ]}>{species.name}</Text>
              <Text style={styles.scientificName}>{species.scientificName}</Text>
            </View>
            <View style={[
              styles.statusBadge,
              { backgroundColor: species.conservationStatus.color }
            ]}>
              <Text style={styles.statusText}>{species.conservationStatus.status}</Text>
            </View>
          </View>

          <View style={styles.section}>
            <Text style={[
              styles.sectionTitle,
              { color: isDark ? '#fff' : '#000' }
            ]}>Description</Text>
            <Text style={[
              styles.description,
              { color: isDark ? '#aaa' : '#666' }
            ]}>{species.description}</Text>
          </View>

          <View style={styles.section}>
            <Text style={[
              styles.sectionTitle,
              { color: isDark ? '#fff' : '#000' }
            ]}>Characteristics</Text>
            {species.characteristics.map((characteristic, index) => (
              <View key={index} style={styles.characteristicItem}>
                <MaterialCommunityIcons name="circle-medium" size={24} color="#2E7D32" />
                <Text style={[
                  styles.characteristicText,
                  { color: isDark ? '#aaa' : '#666' }
                ]}>{characteristic}</Text>
              </View>
            ))}
          </View>

          <View style={styles.section}>
            <Text style={[
              styles.sectionTitle,
              { color: isDark ? '#fff' : '#000' }
            ]}>Habitat & Distribution</Text>
            <Text style={[
              styles.description,
              { color: isDark ? '#aaa' : '#666' }
            ]}>
              <Text style={{ fontWeight: '600' }}>Habitat: </Text>
              {species.habitat}
            </Text>
            <Text style={[
              styles.description,
              { color: isDark ? '#aaa' : '#666' }
            ]}>
              <Text style={{ fontWeight: '600' }}>Distribution: </Text>
              {species.distribution}
            </Text>
          </View>

          <View style={styles.section}>
            <Text style={[
              styles.sectionTitle,
              { color: isDark ? '#fff' : '#000' }
            ]}>Fun Facts</Text>
            {species.funFacts.map((fact, index) => (
              <View key={index} style={styles.factItem}>
                <MaterialCommunityIcons name="star" size={20} color="#2E7D32" />
                <Text style={[
                  styles.factText,
                  { color: isDark ? '#aaa' : '#666' }
                ]}>{fact}</Text>
              </View>
            ))}
          </View>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity
          style={styles.arButton}
          onPress={() => router.push('/ar-view')}
        >
          <MaterialCommunityIcons name="cube-scan" size={24} color="#fff" />
          <Text style={styles.arButtonText}>View in AR</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorText: {
    fontSize: 18,
    color: '#666',
  },
  image: {
    width: '100%',
    height: 300,
  },
  header: {
    position: 'absolute',
    top: 60,
    left: 0,
    right: 0,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  favoriteButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    padding: 20,
  },
  titleSection: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 20,
  },
  name: {
    fontSize: 28,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  scientificName: {
    fontSize: 16,
    color: '#2E7D32',
    fontStyle: 'italic',
  },
  statusBadge: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
  },
  statusText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: '600',
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 12,
  },
  description: {
    fontSize: 16,
    lineHeight: 24,
  },
  characteristicItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  characteristicText: {
    fontSize: 16,
    flex: 1,
  },
  factItem: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 12,
    paddingRight: 20,
  },
  factText: {
    fontSize: 16,
    flex: 1,
    marginLeft: 8,
  },
  footer: {
    padding: 20,
    borderTopWidth: 1,
    borderTopColor: 'rgba(0,0,0,0.1)',
  },
  arButton: {
    backgroundColor: '#2E7D32',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
  },
  arButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
}); 