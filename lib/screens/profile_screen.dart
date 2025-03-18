import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biolens/providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'john.doe@example.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Settings Section
              _buildSection(
                'App Settings',
                [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: appProvider.isDarkMode,
                    onChanged: (value) => appProvider.toggleTheme(),
                  ),
                  ListTile(
                    title: const Text('Language'),
                    subtitle: Text(appProvider.language.toUpperCase()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Show language selection dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // About Section
              _buildSection(
                'About',
                [
                  ListTile(
                    title: const Text('About Afro-Dip'),
                    subtitle: const Text('Learn more about the app'),
                    leading: const Icon(Icons.info),
                    onTap: () {
                      // TODO: Show about dialog
                    },
                  ),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('View privacy policy'),
                    leading: const Icon(Icons.privacy_tip),
                    onTap: () {
                      // TODO: Show privacy policy
                    },
                  ),
                  ListTile(
                    title: const Text('Terms of Service'),
                    subtitle: const Text('View terms of service'),
                    leading: const Icon(Icons.description),
                    onTap: () {
                      // TODO: Show terms of service
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Support Section
              _buildSection(
                'Support',
                [
                  ListTile(
                    title: const Text('Contact Support'),
                    subtitle: const Text('Get help with the app'),
                    leading: const Icon(Icons.support_agent),
                    onTap: () {
                      // TODO: Show support contact options
                    },
                  ),
                  ListTile(
                    title: const Text('Report a Bug'),
                    subtitle: const Text('Submit bug report'),
                    leading: const Icon(Icons.bug_report),
                    onTap: () {
                      // TODO: Show bug report form
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
} 