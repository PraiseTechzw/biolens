class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.biolens.com';
  static const String speciesEndpoint = '/species';
  static const String identifyEndpoint = '/identify';
  static const String userEndpoint = '/user';
  static const String communityEndpoint = '/community';
  
  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'has_seen_onboarding';
  static const String themeKey = 'app_theme';
  static const String recentSearchesKey = 'recent_searches';
  static const String favoritesKey = 'favorites';
  static const String recentIdentificationsKey = 'recent_identifications';
  
  // App Settings
  static const int maxRecentSearches = 10;
  static const int maxRecentIdentifications = 20;
  static const int maxCachedSpecies = 100;
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection and try again.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String identificationErrorMessage = 'Could not identify the fly. Please try again with a clearer image.';
  static const String authErrorMessage = 'Authentication failed. Please check your credentials and try again.';
  static const String cameraErrorMessage = 'Could not access camera. Please check your permissions.';
  static const String locationErrorMessage = 'Could not access location. Please check your permissions.';
  
  // Success Messages
  static const String identificationSuccessMessage = 'Fly identified successfully!';
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
  static const String logoutSuccessMessage = 'Logout successful!';
  static const String feedbackSuccessMessage = 'Thank you for your feedback!';
  static const String sightingSuccessMessage = 'Sighting added successfully!';
  
  // Permissions
  static const String cameraPermissionRationale = 'BioLens needs camera access to identify flies.';
  static const String locationPermissionRationale = 'BioLens needs location access to track fly sightings.';
  static const String storagePermissionRationale = 'BioLens needs storage access to save images.';
  
  // App Info
  static const String appVersion = '1.0.0';
  static const String appName = 'BioLens';
  static const String appDescription = 'AI-powered fly identification app';
  static const String appWebsite = 'https://www.biolens.com';
  static const String supportEmail = 'support@biolens.com';
  static const String privacyPolicyUrl = 'https://www.biolens.com/privacy';
  static const String termsOfServiceUrl = 'https://www.biolens.com/terms';
}

