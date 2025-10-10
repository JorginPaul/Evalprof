// Screens
import 'package:EvalProfs/models/user_model.dart';
import 'package:EvalProfs/screen/auth/dashboard_screen.dart';
import 'package:EvalProfs/screen/auth/login_screen.dart';
import 'package:EvalProfs/screen/auth/register_screen.dart';
import 'package:EvalProfs/screen/auth/splash_page.dart';
import 'package:EvalProfs/screen/corrections/correction_detail_screen.dart';
import 'package:EvalProfs/screen/corrections/correction_panel.dart';
import 'package:EvalProfs/screen/corrections/new_correction_screen.dart';
import 'package:EvalProfs/screen/corrections/pending_reviews.dart';
import 'package:EvalProfs/screen/corrections/total_comments.dart';
import 'package:EvalProfs/screen/courses/course_detail_screen.dart';
import 'package:EvalProfs/screen/courses/course_library_screen.dart';
import 'package:EvalProfs/screen/courses/course_upload_screen.dart';
import 'package:EvalProfs/screen/evaluations/evaluation_generator_screen.dart';
import 'package:EvalProfs/screen/evaluations/evaluation_list_screen.dart';
import 'package:EvalProfs/screen/friends/friend_list_screen.dart';
import 'package:EvalProfs/screen/friends/friend_search_screen.dart';
import 'package:EvalProfs/screen/notifications/notification_screen.dart';
import 'package:EvalProfs/screen/profile/edit_profile.dart';
import 'package:EvalProfs/screen/profile/profile_screen.dart';
import 'package:EvalProfs/screen/chat/chat_screen.dart';
import 'package:EvalProfs/services/chat_service.dart';
import 'package:EvalProfs/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.tryAutoLogin();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatService(token: '')),
        ChangeNotifierProvider(create: (_) => AuthService()),
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
        '/splashpage': (_) => SplashScreens(),
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
        '/course-detail': (_) => const CourseDetailScreen(),
      },
      
      // onGenerateRoute for dynamic details
      onGenerateRoute: (settings) {
        // Course details Route
        if (settings.name == '/course-detail') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) => CourseDetailScreen(courseId: args['id'] ?? ''),
          );
        }
        if (settings.name == '/correction-detail') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) =>
                CorrectionDetailScreen(correctionId: args['id'] ?? ''),
          );
        }
        // Chat Route
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          final conversationId = args['conversationId'] as String? ?? '';
          final otherUser = args['otherUser'] as UserModel;
          
            return MaterialPageRoute(
              builder: (_) => ChatScreen(
                conversationId: 'conversationId',
                otherUser: otherUser,
              ),
            );
          }

        return null;
      },
    );
  }
}
