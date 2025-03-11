import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, Switch, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

interface SettingsSectionProps {
  title: string;
  children: React.ReactNode;
}

interface SettingsItemProps {
  title: string;
  description?: string;
  type: 'toggle' | 'button';
  value?: boolean;
  onPress?: () => void;
  onValueChange?: (value: boolean) => void;
}

const SettingsSection: React.FC<SettingsSectionProps> = ({ title, children }) => (
  <View style={styles.section}>
    <Text style={styles.sectionTitle}>{title}</Text>
    {children}
  </View>
);

const SettingsItem: React.FC<SettingsItemProps> = ({
  title,
  description,
  type,
  value,
  onPress,
  onValueChange,
}) => (
  <TouchableOpacity
    style={styles.settingsItem}
    onPress={type === 'button' ? onPress : undefined}
  >
    <View style={styles.settingsItemContent}>
      <View>
        <Text style={styles.settingsItemTitle}>{title}</Text>
        {description && (
          <Text style={styles.settingsItemDescription}>{description}</Text>
        )}
      </View>
      {type === 'toggle' && (
        <Switch
          value={value}
          onValueChange={onValueChange}
          trackColor={{ false: '#767577', true: '#81b0ff' }}
          thumbColor={value ? '#2196F3' : '#f4f3f4'}
        />
      )}
      {type === 'button' && (
        <Ionicons name="chevron-forward" size={24} color="#666" />
      )}
    </View>
  </TouchableOpacity>
);

export default function SettingsScreen() {
  const [highQualityCamera, setHighQualityCamera] = useState(true);
  const [offlineMode, setOfflineMode] = useState(false);
  const [dataSharing, setDataSharing] = useState(true);
  const [notifications, setNotifications] = useState(true);

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Settings</Text>
      </View>

      <SettingsSection title="Camera">
        <SettingsItem
          title="High Quality Camera"
          description="Use higher resolution for better identification accuracy"
          type="toggle"
          value={highQualityCamera}
          onValueChange={setHighQualityCamera}
        />
        <SettingsItem
          title="Offline Mode"
          description="Download species database for offline use"
          type="toggle"
          value={offlineMode}
          onValueChange={setOfflineMode}
        />
      </SettingsSection>

      <SettingsSection title="Privacy">
        <SettingsItem
          title="Data Sharing"
          description="Help improve species identification by sharing anonymous data"
          type="toggle"
          value={dataSharing}
          onValueChange={setDataSharing}
        />
        <SettingsItem
          title="Notifications"
          description="Receive updates about new features and discoveries"
          type="toggle"
          value={notifications}
          onValueChange={setNotifications}
        />
      </SettingsSection>

      <SettingsSection title="Account">
        <SettingsItem
          title="Premium Subscription"
          description="Manage your subscription"
          type="button"
          onPress={() => {}}
        />
        <SettingsItem
          title="Change Password"
          description="Update your account password"
          type="button"
          onPress={() => {}}
        />
      </SettingsSection>

      <SettingsSection title="Support">
        <SettingsItem
          title="Help Center"
          description="Get help with using the app"
          type="button"
          onPress={() => {}}
        />
        <SettingsItem
          title="About"
          description="App version and legal information"
          type="button"
          onPress={() => {}}
        />
      </SettingsSection>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    padding: 20,
    paddingTop: 60,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#666',
    marginBottom: 15,
  },
  settingsItem: {
    backgroundColor: '#f8f8f8',
    borderRadius: 10,
    marginBottom: 10,
  },
  settingsItemContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 15,
  },
  settingsItemTitle: {
    fontSize: 16,
    fontWeight: '500',
  },
  settingsItemDescription: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
    maxWidth: '90%',
  },
}); 