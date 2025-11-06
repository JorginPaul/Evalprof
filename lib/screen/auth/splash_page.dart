import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../auth/dashboard_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _checkingLogin = true;

  final List<SplashPage> _pages = [
    SplashPage(
      title: 'Transform Education\nAcross Africa',
      subtitle:
          'Join a revolutionary platform where educators collaborate, share, and elevate academic excellence together',
      backgroundImage: 'assets/images/1.jpg',
      icon: '🌍',
      emoji: '👥',
      features: [
        Feature(emoji: '👨‍🏫', text: 'Connect with 1000+ Educators'),
        Feature(emoji: '📚', text: 'Share Quality Resources'),
        Feature(emoji: '🏆', text: 'Build Your Academic Legacy'),
      ],
      illustrationType: IllustrationType.collaborative,
    ),
    SplashPage(
      title: 'AI-Powered\nEvaluation Generation',
      subtitle:
          'Create contextual, high-quality assessments in minutes with intelligent AI assistance tailored to your curriculum',
      backgroundImage: 'assets/images/2.jpg',
      icon: '🤖',
      emoji: '✨',
      features: [
        Feature(emoji: '📝', text: 'Smart Question Generation'),
        Feature(emoji: '📖', text: 'Contextual to Your Syllabus'),
        Feature(emoji: '✅', text: 'CA & Exam Ready'),
      ],
      illustrationType: IllustrationType.ai,
    ),
    SplashPage(
      title: 'Elevate Your\nTeaching Impact',
      subtitle:
          'Access peer-reviewed materials, give and receive feedback, and continuously improve your educational content',
      backgroundImage: 'assets/images/3.jpg',
      icon: '📈',
      emoji: '🎓',
      features: [
        Feature(emoji: '⭐', text: 'Peer Review & Feedback'),
        Feature(emoji: '🏅', text: 'Quality-Rated Content'),
        Feature(emoji: '🎯', text: 'Professional Growth'),
      ],
      illustrationType: IllustrationType.growth,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.tryAutoLogin();

    if (!mounted) return;

    setState(() => _checkingLogin = false);

    // Automatically navigate if already logged in
    if (auth.isLoggedIn) {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const DashboardScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLogin) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildSplashPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 20,
                top: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 20),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashPage(SplashPage page) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isMediumScreen = screenHeight >= 700 && screenHeight < 850;

    final iconSize = isSmallScreen ? 100.0 : (isMediumScreen ? 120.0 : 140.0);
    final titleFontSize = isSmallScreen ? 28.0 : (isMediumScreen ? 32.0 : 36.0);
    final subtitleFontSize = isSmallScreen ? 14.0 : 16.0;
    final featureFontSize = isSmallScreen ? 14.0 : 16.0;
    final topPadding = screenHeight * 0.08;
    final contentPadding = isSmallScreen ? 16.0 : 24.0;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            page.backgroundImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getGradientColors(page.illustrationType),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: contentPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: topPadding),
                    _buildIllustration(page.illustrationType, page.emoji, iconSize),
                    SizedBox(height: isSmallScreen ? 24 : 40),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white.withOpacity(0.95),
                          height: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    ...page.features.asMap().entries.map(
                          (entry) => _buildFeatureItem(
                            entry.value,
                            featureFontSize,
                            isSmallScreen,
                            key: ValueKey('feature_${_currentPage}_${entry.key}'),
                          ),
                        ),
                    SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(IllustrationType type) {
    switch (type) {
      case IllustrationType.collaborative:
        return [Color(0xFFEF4444), Color(0xFFEC4899), Color(0xFFF43F5E)];
      case IllustrationType.ai:
        return [Color(0xFFA855F7), Color(0xFF6366F1), Color(0xFF3B82F6)];
      case IllustrationType.growth:
        return [Color(0xFFF97316), Color(0xFFEF4444), Color(0xFFEC4899)];
    }
  }

  Widget _buildIllustration(IllustrationType type, String emoji, double size) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: _getGradientColors(type)[0].withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: size * 0.5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(Feature feature, double fontSize, bool isSmall, {Key? key}) {
    return Padding(
      key: key,
      padding: EdgeInsets.only(bottom: isSmall ? 12 : 16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 20,
          vertical: isSmall ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isSmall ? 40 : 48,
              height: isSmall ? 40 : 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  feature.emoji,
                  style: TextStyle(fontSize: isSmall ? 20 : 24),
                ),
              ),
            ),
            SizedBox(width: isSmall ? 12 : 16),
            Expanded(
              child: Text(
                feature.text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_currentPage == index ? 1 : 0.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _currentPage == index
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentPage > 0)
          TextButton.icon(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            label: const Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          )
        else
          const SizedBox(width: 80),
        ElevatedButton(
          onPressed: () {
            if (_currentPage < _pages.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              // If not logged in, navigate to login
              final auth = Provider.of<AuthService>(context, listen: false);
              if (auth.isLoggedIn) {
                _navigateToDashboard();
              } else {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(milliseconds: 800),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFEF4444),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: const Color.fromARGB(255, 199, 194, 194).withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SplashPage {
  final String title;
  final String subtitle;
  final String backgroundImage;
  final String icon;
  final String emoji;
  final List<Feature> features;
  final IllustrationType illustrationType;

  SplashPage({
    required this.title,
    required this.subtitle,
    required this.backgroundImage,
    required this.icon,
    required this.emoji,
    required this.features,
    required this.illustrationType,
  });
}

class Feature {
  final String emoji;
  final String text;

  Feature({required this.emoji, required this.text});
}

enum IllustrationType {
  collaborative,
  ai,
  growth,
}