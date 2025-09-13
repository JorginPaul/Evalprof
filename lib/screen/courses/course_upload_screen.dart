import 'package:flutter/material.dart';

class CourseUploadScreen extends StatefulWidget {
  const CourseUploadScreen({super.key});

  @override
  State<CourseUploadScreen> createState() => _CourseUploadScreenState();
}

class _CourseUploadScreenState extends State<CourseUploadScreen> {
  final _form = GlobalKey<FormState>();
  String title = '';
  String? level;
  String? description;

  void _submit() async {
    if (!_form.currentState!.validate() || level == null) return;
    await Future.delayed(const Duration(milliseconds: 600)); // simulate
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload New Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Course Title'),
                onChanged: (v) => title = v,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter course title' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: level,
                decoration: const InputDecoration(labelText: 'Level'),
                items: ['100', '200', '300', '400']
                    .map(
                      (lvl) => DropdownMenuItem(
                        value: lvl,
                        child: Text('Level $lvl'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => level = v),
                validator: (v) => v == null ? 'Select a level' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                onChanged: (v) => description = v,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
