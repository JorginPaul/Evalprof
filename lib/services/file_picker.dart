import 'package:file_picker/file_picker.dart';

// Alternative approach
Future<void> pickFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    
    if (result != null) {
      PlatformFile file = result.files.first;
      print('File name: ${file.name}');
      print('File size: ${file.size}');
      print('File extension: ${file.extension}');
      print('File path: ${file.path}');
    }
  } catch (e) {
    print('Error picking file: $e');
  }
}