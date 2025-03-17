import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutHelpScreen extends StatelessWidget {
  const AboutHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App logo and version
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'BioLens',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // About section
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'BioLens is an AI-powered fly identification app designed to help researchers, enthusiasts, and the general public identify and learn about various fly species. The app uses machine learning to analyze images and provide accurate species identification.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Features section
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            icon: Icons.camera_alt,
            title: 'AI-Powered Identification',
            description: 'Identify fly species using your camera or gallery images.',
          ),
          _buildFeatureItem(
            icon: Icons.search,
            title: 'Comprehensive Database',
            description: 'Access detailed information about various fly species.',
          ),
          _buildFeatureItem(
            icon: Icons.map,
            title: 'Location Tracking',
            description: 'Track and map fly sightings in your area.',
          ),
          _buildFeatureItem(
            icon: Icons.people,
            title: 'Community',
            description: 'Share discoveries and learn from other users.',
          ),
          
          const SizedBox(height: 24),
          
          // FAQ section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'How accurate is the identification?',
            answer: 'Our AI model has been trained on thousands of fly images and achieves an accuracy of over 90% for common species. However, accuracy may vary for rare species or poor-quality images.',
          ),
          _buildFaqItem(
            context,
            question: 'Can I use the app offline?',
            answer: 'Basic features like viewing previously downloaded species information work offline. However, identification and community features require an internet connection.',
          ),
          _buildFaqItem(
            context,
            question: 'How can I improve identification accuracy?',
            answer: 'Take clear, well-lit photos of the fly from multiple angles if possible. Including size reference can also help with identification.',
          ),
          _buildFaqItem(
            context,
            question: 'How do I report a bug or suggest a feature?',
            answer: 'You can contact our support team through the app or email us at support@biolens.com.',
          ),
          
          const SizedBox(height: 24),
          
          // Contact section
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    value: 'support@biolens.com',
                    onTap: () {
                      _launchUrl('mailto:support@biolens.com');
                    },
                  ),
                  const Divider(),
                  _buildContactItem(
                    icon: Icons.language,
                    title: 'Website',
                    value: 'www.biolens.com',
                    onTap: () {
                      _launchUrl('https://www.biolens.com');
                    },
                  ),
                  const Divider(),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: '+1 (555) 123-4567',
                    onTap: () {
                      _launchUrl('tel:+15551234567');
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Credits section
          const Text(
            'Credits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BioLens was developed by the BioTech Team.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Special thanks to:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('• Dr. Jane Smith for scientific consultation'),
                  Text('• University of Biology for research support'),
                  Text('• Global Entomology Association for data access'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Legal section
          const Text(
            'Legal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Terms of Service
              _showLegalDocument(context, 'Terms of Service');
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Privacy Policy
              _showLegalDocument(context, 'Privacy Policy');
            },
          ),
          ListTile(
            title: const Text('Licenses'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show open source licenses
              showLicensePage(
                context: context,
                applicationName: 'BioLens',
                applicationVersion: '1.0.0',
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // App version and copyright
          Center(
            child: Column(
              children: [
                const Text(
                  '© 2023 BioLens. All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    // Check for updates
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your app is up to date!'),
                      ),
                    );
                  },
                  child: const Text('Check for Updates'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFaqItem(
    BuildContext context,
    {required String question, required String answer}
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.green,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  void _showLegalDocument(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              'This is a placeholder for the $title. In a real app, this would contain the actual legal document text.',
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

