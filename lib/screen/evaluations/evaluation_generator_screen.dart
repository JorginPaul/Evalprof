import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../utils/helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/bottom_navbar.dart';

class EvaluationGeneratorScreen extends StatefulWidget {
  const EvaluationGeneratorScreen({super.key});

  @override
  _EvaluationGeneratorScreenState createState() =>
      _EvaluationGeneratorScreenState();
}

class _EvaluationGeneratorScreenState extends State<EvaluationGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  
  String evaluationType = 'Select Evaluation Type';
  String complexityLevel = 'Select Complexity Level';
  String courseSubject = 'Select Course Subject';
  String generatedEvaluation = '';
  bool loading = false;

  final List<String> evaluationTypes = [
    'Select Evaluation Type',
    'Continuous Assessment (CA)',
    'Mid-term Exam',
    'Final Exam',
    'Quiz',
    'Assignment'
  ];

  final List<String> complexityLevels = [
    'Select Complexity Level',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];

  final List<String> courseSubjects = [
    'Select Course Subject',
    'Mathematics',
    'Computer Science',
    'Physics',
    'Chemistry',
    'Biology',
    'Literature',
    'History',
    'Economics',
    'Business Administration'
  ];

  Future<void> _generateEvaluation() async {
    if (_formKey.currentState!.validate() &&
        evaluationType != 'Select Evaluation Type' &&
        complexityLevel != 'Select Complexity Level' &&
        courseSubject != 'Select Course Subject') {
      
      setState(() => loading = true);

      // TODO: Replace this with actual API call to your backend/GPT
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        loading = false;
        generatedEvaluation = '''
COURSE: $courseSubject
TYPE: $evaluationType
LEVEL: $complexityLevel

QUESTIONS:

1. Define the fundamental concepts covered in the course material and explain their significance in the context of $courseSubject.

2. Analyze and compare the key theoretical frameworks discussed in the uploaded content. Provide specific examples to support your analysis.

3. Apply the concepts from the course material to solve a real-world problem. Demonstrate your understanding through detailed explanations.

4. Evaluate the effectiveness of the methodologies presented in the course content. What are their strengths and limitations?

5. Synthesize the information from multiple topics covered in the material to propose an innovative solution or approach.

MARKING SCHEME:
- Question 1: 20 marks
- Question 2: 20 marks  
- Question 3: 25 marks
- Question 4: 20 marks
- Question 5: 15 marks
Total: 100 marks

Time Allocation: 2 hours
        ''';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields before generating evaluation'),
          backgroundColor: Color(0xFFFF4444),
        ),
      );
    }
  }

  void _copyEvaluation() async {
    if (generatedEvaluation.isNotEmpty) {
      try {
        // Copy the evaluation text to clipboard
        await Clipboard.setData(ClipboardData(text: generatedEvaluation));
        
        // Show success message with icon
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 6),
                Text('Evaluation copied to clipboard'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Handle error case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 6),
                Text('Failed to copy to clipboard'),
              ],
            ),
            backgroundColor: Color(0xFFFF4444),
          ),
        );
      }
    }
  }

  void _refineEvaluation() {
    if (generatedEvaluation.isNotEmpty) {
      // Show dialog for refinement instructions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String refinementInstruction = '';
          
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Refine Evaluation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How would you like to refine this evaluation?',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (value) => refinementInstruction = value,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Examples:\n• Add more practical questions\n• Make questions shorter\n• Include case studies\n• Focus on specific topics',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (refinementInstruction.isNotEmpty) {
                    _generateRefinedEvaluation(refinementInstruction);
                  } else {
                    _generateEvaluation(); // Default regeneration
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Refine'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _generateRefinedEvaluation(String refinementInstruction) async {
    setState(() => loading = true);

    try {
      // TODO: Replace with actual API call to your backend/GPT
      // Include the refinement instruction in the prompt
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        loading = false;
        generatedEvaluation = '''
  REFINED EVALUATION - $courseSubject
  Type: $evaluationType | Level: $complexityLevel
  Refinement Applied: "$refinementInstruction"

  ═══════════════════════════════════════════════════

  SECTION A: REFINED QUESTIONS

  1. [ENHANCED] Based on the course material provided, critically analyze the fundamental concepts of $courseSubject and demonstrate their practical applications in real-world scenarios. (20 marks)

  2. [IMPROVED] Compare and contrast the key theoretical frameworks discussed in your course content. Support your analysis with specific examples and evidence from the material. (20 marks)

  3. [REFINED] Design a comprehensive solution to address a complex problem in $courseSubject using the methodologies covered in the course. Provide detailed implementation steps and justify your approach. (25 marks)

  4. [ENHANCED] Evaluate the strengths and limitations of the approaches presented in your course material. Propose improvements based on current industry practices and emerging trends. (20 marks)

  5. [ADVANCED] Synthesize concepts from multiple topics in the course material to create an innovative framework or solution. Defend your approach with solid theoretical foundations. (15 marks)

  ═══════════════════════════════════════════════════

  MARKING SCHEME:
  • Excellent (90-100%): Demonstrates exceptional understanding with innovative insights
  • Good (75-89%): Shows solid grasp with good practical application
  • Satisfactory (60-74%): Adequate understanding with basic application
  • Needs Improvement (40-59%): Limited understanding, requires more study
  • Unsatisfactory (0-39%): Insufficient knowledge demonstrated

  TIME ALLOCATION: 2.5 hours
  TOTAL MARKS: 100

  Instructions for Students:
  - Answer ALL questions
  - Show all working where applicable  
  - Use examples from course material
  - Write clearly and legibly

  Refined based on: "$refinementInstruction"
  Generated by EvalProfs AI - ${DateTime.now().toString().split('.')[0]}
        ''';
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text('Evaluation refined successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to refine evaluation. Please try again.'),
          backgroundColor: Color(0xFFFF4444),
        ),
      );
    }
  }

  void _downloadEvaluation() async {
    if (generatedEvaluation.isNotEmpty) {
      try {
        // Check and request storage permission
        PermissionStatus permission = await Permission.storage.status;
        if (!permission.isGranted) {
          permission = await Permission.storage.request();
          if (!permission.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Storage permission required to download'),
                  ],
                ),
                backgroundColor: Color(0xFFFF4444),
              ),
            );
            return;
          }
        }

        // Get appropriate directory based on platform
        Directory? directory;
        String directoryPath = '';
        
        if (Platform.isAndroid) {
          // Try to use Downloads directory first
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            // Fallback to external storage
            directory = await getExternalStorageDirectory();
          }
          directoryPath = directory?.path ?? '';
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
          directoryPath = directory.path;
        } else {
          // For other platforms (Windows, macOS, Linux)
          directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
          directoryPath = directory.path;
        }

        if (directoryPath.isNotEmpty) {
          // Create unique filename with timestamp
          final timestamp = DateTime.now();
          final formattedDate = '${timestamp.day}-${timestamp.month}-${timestamp.year}_${timestamp.hour}-${timestamp.minute}';
          final subjectName = courseSubject.replaceAll(' ', '_').toLowerCase();
          final filename = 'evalprofs_${subjectName}_${evaluationType.replaceAll(' ', '_').toLowerCase()}_$formattedDate.txt';
          final filePath = '$directoryPath/$filename';
          final file = File(filePath);

          // Create comprehensive file content with EvalProfs branding
          final fileContent = '''
  ╔══════════════════════════════════════════════════════════════════╗
  ║                         EVALPROFS                                ║  
  ║              AI-GENERATED EDUCATIONAL EVALUATION                 ║
  ╚══════════════════════════════════════════════════════════════════╝

  EVALUATION DETAILS:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  • Generated Date: ${timestamp.toString().split('.')[0]}
  • Course Subject: $courseSubject
  • Evaluation Type: $evaluationType  
  • Complexity Level: $complexityLevel
  • Generated by: EvalProfs AI Evaluation Generator
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  EVALUATION CONTENT:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  $generatedEvaluation

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ABOUT EVALPROFS:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EvalProfs is an innovative platform that enhances the quality and 
  contextual relevance of educational evaluations across Africa through 
  AI-powered collaborative tools for educators.

  For more information: www.evalprofs.com
  Support: support@evalprofs.com

  © ${timestamp.year} EvalProfs. All rights reserved.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ''';

          // Write file to storage
          await file.writeAsString(fileContent);

          // Show success message with file path
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.download_done, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Evaluation downloaded successfully!'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Saved as: $filename',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    'Location: $directoryPath',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        } else {
          throw Exception('Could not access storage directory');
        }
      } catch (e) {
        // Handle any errors during download
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Download failed: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFF4444),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == items[0] ? Colors.grey.shade600 : Colors.black87,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Evaluation Generator',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF4444)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Center(
                child: Text(
                  'Utilize AI to craft comprehensive evaluations from your course content.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Input Course Material Section
              const Text(
                'Input Course Material',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Course Material Input
              Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: TextFormField(
                  controller: _courseController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Paste your course material, lecture notes, or topic outline here...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please enter course material' : null,
                ),
              ),
              const SizedBox(height: 24),

              // Dropdowns
              _buildDropdown(
                value: evaluationType,
                items: evaluationTypes,
                onChanged: (String? newValue) {
                  setState(() {
                    evaluationType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                value: complexityLevel,
                items: complexityLevels,
                onChanged: (String? newValue) {
                  setState(() {
                    complexityLevel = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                value: courseSubject,
                items: courseSubjects,
                onChanged: (String? newValue) {
                  setState(() {
                    courseSubject = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : _generateEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Generate Evaluation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // Generated Evaluation Section
              const Text(
                'Generated Evaluation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Generated Content Container
              Container(
                width: double.infinity,
                //min: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: generatedEvaluation.isEmpty
                    ? Center(
                        child: Text(
                          'Your AI-generated evaluation will appear here.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : SelectableText(
                        generatedEvaluation,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
              ),

              // Action Buttons
              if (generatedEvaluation.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _copyEvaluation,
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        label: const Text('Copy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF4444),
                          side: const BorderSide(color: Color(0xFFFF4444)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _refineEvaluation,
                        icon: const Icon(Icons.tune_outlined, size: 18),
                        label: const Text('Refine'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF4444),
                          side: const BorderSide(color: Color(0xFFFF4444)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _downloadEvaluation,
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF4444),
                      side: const BorderSide(color: Color(0xFFFF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 2,
        onTap: (i) {
          switch (i) {
            case 0:
              replace(context, '/dashboard');
              break;
            case 1:
            replace(context, '/course-list');
              break;
            case 2:
              break;
            case 3:
              replace(context, '/corrections');
              break;
            case 4:
              replace(context, '/friends');
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }
}