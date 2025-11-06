// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:EvalProfs/constants/app_constants.dart';
import 'package:EvalProfs/screen/notifications/notification_screen.dart';
import 'package:EvalProfs/screen/profile/profile_screen.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';

class CourseUploadScreen extends StatefulWidget {
  const CourseUploadScreen({super.key});

  @override
  State<CourseUploadScreen> createState() => _CourseUploadScreenState();
}

class _CourseUploadScreenState extends State<CourseUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();

  String? _selectedAcademicYear = '2023-2024';
  String? _selectedFileName;
  String? _selectedFilePath;
  final List<String> _subjectTags = ['Computer Science', 'Data Structures', 'Algorithms'];

  // Pick file
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'mp3', 'mp4'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      _showSnack('File selection failed. Please try again.', isError: true);
    }
  }

  // Upload file
  Future<void> _uploadFile(String filePath) async {
    final uri = Uri.parse("${AppConstants.apiBaseUrl}/courses/upload_course");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      _showSnack('File uploaded successfully!');
    } else {
      _showSnack('Upload failed (Status: ${response.statusCode})', isError: true);
    }
  }

  // Add tag
  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_subjectTags.contains(tag)) {
      setState(() => _subjectTags.add(tag));
      _tagController.clear();
    }
  }

  // Remove tag
  void _removeTag(String tag) {
    setState(() => _subjectTags.remove(tag));
  }

  // Snack utility
  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Form submission
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedFilePath == null ||
        _subjectTags.isEmpty) {
      _showSnack('Please fill all required fields.', isError: true);
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _uploadFile(_selectedFilePath!);
      if (mounted) {
        Navigator.pop(context);
        _showSnack('Course uploaded successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showSnack('An error occurred during upload.', isError: true);
      }
    }
  }

  // ------------------------- UI BUILDING --------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildFileSection(),
              const SizedBox(height: 16),
              _buildNoticeCard(),
              const SizedBox(height: 24),
              _buildTagsSection(),
              const SizedBox(height: 24),
              _buildAcademicYearSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        onTap: (i) => _onBottomNavTap(i, context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFFF4444)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Upload Course',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF4444)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationScreen()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFF4444),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileSection() {
    return _styledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course File',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.attach_file_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedFileName ?? 'No file chosen',
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedFileName != null ? Colors.black87 : Colors.grey[500],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _pickFile,
                style: _buttonStyle(),
                child: const Text(
                  'Choose File',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All uploaded files are scanned for viruses to maintain platform security. Ensure your file is clean before upload.',
              style: TextStyle(fontSize: 12, color: Colors.blue[700], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return _styledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Tags',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_subjectTags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _subjectTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFFFF4444),
                  deleteIcon: const Icon(Icons.close, color: Colors.white, size: 14),
                  onDeleted: () => _removeTag(tag),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _tagController,
            decoration: InputDecoration(
              hintText: 'Add a subject tag (e.g., Physics)',
              suffixIcon: IconButton(
                onPressed: _addTag,
                icon: const Icon(Icons.add, color: Color(0xFFFF4444)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onSubmitted: (_) => _addTag(),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicYearSection() {
    return _styledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Year',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedAcademicYear,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ['2023-2024', '2024-2025', '2025-2026']
                .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                .toList(),
            onChanged: (value) => setState(() => _selectedAcademicYear = value),
            validator: (v) => v == null ? 'Select an academic year' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _submit,
            style: _buttonStyle(),
            child: const Text(
              'Upload Course',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFFFF4444),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // -------------------- UI UTILITIES -------------------- //
  BoxDecoration _boxShadow() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  Widget _styledContainer({required Widget child}) =>
      Container(padding: const EdgeInsets.all(16), decoration: _boxShadow(), child: child);

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF4444),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      );

  void _onBottomNavTap(int index, BuildContext context) {
    const routes = [
      '/dashboard',
      '/library',
      '/evaluation-generator',
      '/corrections',
      '/friends'
    ];
    replace(context, routes[index]);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}