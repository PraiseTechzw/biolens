import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:afro_dip/providers/auth_provider.dart';
import 'package:afro_dip/providers/identification_provider.dart';
import 'package:afro_dip/screens/capture_screen.dart';
import 'package:afro_dip/screens/fly_library_screen.dart';
import 'package:afro_dip/screens/profile_screen.dart';
import 'package:afro_dip/screens/results_history_screen.dart';
import 'package:afro_dip/screens/trending_screen.dart';
import 'package:afro_dip/widgets/fly_of_the_day_card.dart';
import 'package:afro_dip/widgets/recent_identifications_list.dart';
import 'package:afro_dip/widgets/trending_identifications_list.dart';
import 'package:afro_dip/widgets/fly_logo.dart';
import 'package:afro_dip/utils/app_theme.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(onNavigate: _navigateToScreen),
      const FlyLibraryScreen(),
      const TrendingScreen(),
      const ResultsHistoryScreen(),
      const ProfileScreen(),
    ];
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Add haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  _navigateToScreen(index);
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                animationDuration: const Duration(milliseconds: 400),
                destinations: [
                  _buildNavDestination(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: _currentIndex == 0,
                  ),
                  _buildNavDestination(
                    icon: Icons.menu_book_outlined,
                    selectedIcon: Icons.menu_book_rounded,
                    label: 'Library',
                    isSelected: _currentIndex == 1,
                  ),
                  _buildNavDestination(
                    icon: Icons.trending_up_outlined,
                    selectedIcon: Icons.trending_up_rounded,
                    label: 'Trending',
                    isSelected: _currentIndex == 2,
                  ),
                  _buildNavDestination(
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history_rounded,
                    label: 'History',
                    isSelected: _currentIndex == 3,
                  ),
                  _buildNavDestination(
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: _currentIndex == 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        size: 24,
      ),
      selectedIcon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          selectedIcon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      label: label,
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeContent({super.key, required this.onNavigate});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  bool _isScrolled = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.offset > 10 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 10 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final identificationProvider = Provider.of<IdentificationProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userName = authProvider.name;
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Dynamic Header
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: _isScrolled 
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            elevation: _isScrolled ? 4 : 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [
                            AppTheme.darkBackground,
                            Color.lerp(AppTheme.darkBackground, AppTheme.secondaryGreen, 0.3)!,
                          ]
                        : [
                            Color.lerp(AppTheme.lightBackground, AppTheme.primaryGreen, 0.1)!,
                            Color.lerp(AppTheme.lightBackground, AppTheme.primaryGreen, 0.2)!,
                          ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DotPatternPainter(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ),
                    
                    // Fly silhouette
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Opacity(
                        opacity: 0.1,
                        child: FlyLogo(
                          size: 150,
                          animate: false,
                          color: isDarkMode
                              ? AppTheme.secondaryGreen
                              : AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    
                    // Welcome text and profile
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userName != null
                                    ? 'Welcome back,'
                                    : 'Welcome to Afro-Dip',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userName ?? 'Diptera Explorer',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to profile
                              widget.onNavigate(4); // Profile tab
                            },
                            child: Hero(
                              tag: 'profile-avatar',
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    userName?.isNotEmpty == true
                                        ? userName![0].toUpperCase()
                                        : 'G',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: _isScrolled
                  ? Row(
                      children: [
                        FlyLogo(
                          size: 30,
                          animate: false,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Afro-Dip',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
                onPressed: () {
                  // Show notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  // Show search
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Search not implemented in demo'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          
          // Enhanced Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Primary Quick Actions - Capture and Upload
                  Row(
                    children: [
                      Expanded(
                        child: _buildPrimaryActionCard(
                          context,
                          'Capture Fly',
                          'Use camera for live detection',
                          Icons.camera_alt_rounded,
                          AppTheme.primaryGreen,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CaptureScreen(source: CaptureSource.camera),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPrimaryActionCard(
                          context,
                          'Upload Image',
                          'Analyze from your gallery',
                          Icons.photo_library_rounded,
                          AppTheme.accentBlue,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CaptureScreen(source: CaptureSource.gallery),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Secondary Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryActionCard(
                          context,
                          'Trending',
                          Icons.local_fire_department_rounded,
                          AppTheme.accentAmber,
                          () {
                            widget.onNavigate(2); // Trending tab
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecondaryActionCard(
                          context,
                          'History',
                          Icons.history_rounded,
                          Colors.purple,
                          () {
                            widget.onNavigate(3); // History tab
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecondaryActionCard(
                          context,
                          'Library',
                          Icons.menu_book_rounded,
                          Colors.teal,
                          () {
                            widget.onNavigate(1); // Library tab
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Featured Content - Fly of the Day
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Species',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Fly of the Day',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const FlyOfTheDayCard(),
                ],
              ),
            ),
          ),
          
          // Recent Identifications
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Identifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          widget.onNavigate(3); // History tab
                        },
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('See All'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const RecentIdentificationsList(),
                ],
              ),
            ),
          ),
          
          // Trending Identifications
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Identifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          widget.onNavigate(2); // Trending tab
                        },
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('See All'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TrendingIdentificationsList(),
                ],
              ),
            ),
          ),
          
          // Tips and Resources
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips & Resources',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      context,
                      'For best identification results, capture flies in good lighting.',
                    ),
                    _buildTipItem(
                      context,
                      'Try to include a size reference in your photos when possible.',
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        // Show more tips
                        _showTipsDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('View More Tips'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrimaryActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        onTap();
        // Add haptic feedback
        HapticFeedback.mediumImpact();
      },
      child: Hero(
        tag: 'action-$title',
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        color.withOpacity(0.2),
                        color.withOpacity(0.3),
                      ]
                    : [
                        color.withOpacity(0.1),
                        color.withOpacity(0.2),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isDarkMode ? 0.2 : 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomPaint(
                      painter: DotPatternPainter(
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? color.withOpacity(0.9) : color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Ripple effect for tap
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onTap,
                      splashColor: color.withOpacity(0.1),
                      highlightColor: color.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        onTap();
        // Add haptic feedback
        HapticFeedback.lightImpact();
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDarkMode
              ? color.withOpacity(0.15)
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDarkMode ? 0.1 : 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            splashColor: color.withOpacity(0.1),
            highlightColor: color.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDarkMode ? 0.2 : 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? color.withOpacity(0.9)
                        : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipItem(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showTipsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Tips for Better Identification',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildTipCard(
                          context,
                          'Lighting',
                          'Ensure good lighting to capture details clearly. Natural daylight works best.',
                          Icons.wb_sunny,
                        ),
                        _buildTipCard(
                          context,
                          'Focus',
                          'Keep the camera steady and ensure the fly is in focus. Use tap-to-focus if available.',
                          Icons.center_focus_strong,
                        ),
                        _buildTipCard(
                          context,
                          'Multiple Angles',
                          'When possible, take photos from different angles to capture all identifying features.',
                          Icons.rotate_90_degrees_ccw,
                        ),
                        _buildTipCard(
                          context,
                          'Size Reference',
                          'Include a common object like a coin for size reference.',
                          Icons.straighten,
                        ),
                        _buildTipCard(
                          context,
                          'Background',
                          'Use a plain, contrasting background to make the fly stand out.',
                          Icons.format_color_fill,
                        ),
                        _buildTipCard(
                          context,
                          'Patience',
                          'Flies move quickly. Be patient and take multiple photos if needed.',
                          Icons.access_time,
                        ),
                        _buildTipCard(
                          context,
                          'Details',
                          'Try to capture wing patterns, eye color, and body markings when possible.',
                          Icons.details,
                        ),
                        _buildTipCard(
                          context,
                          'Location',
                          'Note where you found the fly - habitat information can help with identification.',
                          Icons.location_on,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildTipCard(BuildContext context, String title, String content, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    const spacing = 20.0;
    
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        // Add some randomness to dot size
        final random = math.Random((x * 1000 + y).toInt());
        final dotSize = 1.0 + random.nextDouble();
        
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

