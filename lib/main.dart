// Screens
import 'package:Evalprof/screen/auth/dashboard_screen.dart';
import 'package:Evalprof/screen/auth/login_screen.dart';
import 'package:Evalprof/screen/auth/register_screen.dart';
import 'package:Evalprof/screen/auth/splash_page.dart';
import 'package:Evalprof/screen/corrections/correction_detail_screen.dart';
import 'package:Evalprof/screen/corrections/correction_panel.dart';
import 'package:Evalprof/screen/corrections/new_correction_screen.dart';
import 'package:Evalprof/screen/corrections/pending_reviews.dart';
import 'package:Evalprof/screen/corrections/total_comments.dart';
import 'package:Evalprof/screen/courses/course_detail_screen.dart';
import 'package:Evalprof/screen/courses/course_library_screen.dart';
import 'package:Evalprof/screen/courses/course_upload_screen.dart';
import 'package:Evalprof/screen/evaluations/evaluation_generator_screen.dart';
import 'package:Evalprof/screen/evaluations/evaluation_list_screen.dart';
import 'package:Evalprof/screen/friends/friend_list_screen.dart';
import 'package:Evalprof/screen/friends/friend_search_screen.dart';
import 'package:Evalprof/screen/notifications/notification_screen.dart';
import 'package:Evalprof/screen/profile/edit_profile.dart';
import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LecturerHubApp());
}

class LecturerHubApp extends StatelessWidget {
  const LecturerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvalProf. Lecturer Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/splashpage',
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
        return null;
      },
    );
  }
}
