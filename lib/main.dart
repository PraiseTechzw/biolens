import 'package:afro_dip/providers/auth_provider.dart';
import 'package:afro_dip/providers/identification_provider.dart';
import 'package:afro_dip/providers/theme_provider.dart';
import 'package:afro_dip/screens/splash_screen.dart';
import 'package:afro_dip/services/connectivity_service.dart';
import 'package:afro_dip/services/firebase_service.dart';
import 'package:afro_dip/services/tflite_service.dart';
import 'package:afro_dip/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Firestore with persistence enabled
  await FirebaseFirestore.instance.enablePersistence();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize services
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();

  // Initialize TFLite service
  final tfliteService = TFLiteService();
  await tfliteService.initialize();

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IdentificationProvider()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<TFLiteService>(create: (_) => TFLiteService()),
        Provider<ConnectivityService>(create: (_) => ConnectivityService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Afro-Dip',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
