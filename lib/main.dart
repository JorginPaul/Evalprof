import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';

// Screens
import 'screen/auth/splash_page.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/auth/dashboard_screen.dart';
import 'screen/courses/course_library_screen.dart';
import 'screen/courses/course_upload_screen.dart';
import 'screen/courses/course_detail_screen.dart';
import 'screen/evaluations/evaluation_generator_screen.dart';
import 'screen/evaluations/evaluation_list_screen.dart';
import 'screen/corrections/correction_panel.dart';
import 'screen/corrections/new_correction_screen.dart';
import 'screen/corrections/pending_reviews.dart';
import 'screen/corrections/total_comments.dart';
import 'screen/corrections/correction_detail_screen.dart';
import 'screen/friends/friend_list_screen.dart';
import 'screen/friends/friend_search_screen.dart';
import 'screen/notifications/notification_screen.dart';
import 'screen/profile/profile_screen.dart';
import 'screen/profile/edit_profile.dart';
import 'screen/chat/chat_screen.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final chatService = ChatService(token: '');

  authService.linkChatService(chatService); // Link services

  await authService.tryAutoLogin(); // auto-login first

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: chatService),
      ],
      child: const LecturerHubApp(),
    ),
  );
}

class LecturerHubApp extends StatelessWidget {
  const LecturerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvalProfs. Lecturer Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/splashscreen': (_) => const SplashScreens(),
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/course-list': (_) => const CourseLibraryScreen(),
        '/upload-course': (_) => const CourseUploadScreen(),
        '/evaluation-generator': (_) => EvaluationGeneratorScreen(),
        '/evaluation-list': (_) => const EvaluationListScreen(),
        '/corrections': (_) => const CorrectionListScreen(),
        '/new-correction': (_) => const NewCorrectionScreen(),
        '/friends': (_) => const FriendsScreen(),
        '/friend-search': (_) => const FriendSearchScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/notification': (_) => const NotificationScreen(),
        '/pending-reviews': (_) => const PendingReviewsScreen(),
        '/total-comments': (_) => const TotalCommentsScreen(),
        '/edit_profile': (_) => EditProfile(
              currentName: '',
              currentEmail: '',
              currentRole: '',
              currentBio: '',
              currentDepartment: '',
              currentInstitution: '',
              currentPhone: '',
              currentLocation: '',
              currentProfileImage: '',
            ),
      },
      onGenerateRoute: (settings) {
        // Course details
        if (settings.name == '/course-detail') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) => CourseDetailScreen(courseId: args['id'] ?? ''),
          );
        }

        // Correction details
        if (settings.name == '/correction-detail') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) =>
                CorrectionDetailScreen(correctionId: args['id'] ?? ''),
          );
        }

        // Chat screen
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          final conversationId = args['conversationId'] as String? ?? '';
          final otherUser = args['otherUser'] as UserModel;

          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: conversationId,
              otherUser: otherUser,
            ),
          );
        }

        return null;
      },
    );
  }
}