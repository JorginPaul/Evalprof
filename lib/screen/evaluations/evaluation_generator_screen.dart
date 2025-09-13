import 'package:flutter/material.dart';

class EvaluationGeneratorScreen extends StatefulWidget {
  const EvaluationGeneratorScreen({super.key});

  @override
  _EvaluationGeneratorScreenState createState() =>
      _EvaluationGeneratorScreenState();
}

class _EvaluationGeneratorScreenState extends State<EvaluationGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  String courseTitle = '';
  String topic = '';
  String generatedQuestions = '';
  bool loading = false;

  Future<void> _generateQuestions() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      // TODO: Replace this with actual API call to your backend/GPT
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        loading = false;
        generatedQuestions =
            '''
1) Define $topic and explain its importance in $courseTitle.
2) List and describe three core concepts of $topic.
3) Provide a real-world example where $topic is applied in $courseTitle.
''';
      });
    }
  }

  void _save() async {
    if (generatedQuestions.isEmpty) return;
    // TODO: POST to /evaluations
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Evaluation saved')));
    Navigator.pushNamed(context, '/evaluation-list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Evaluation Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Course Title'),
                onChanged: (val) => courseTitle = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter course title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Topic'),
                onChanged: (val) => topic = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a topic' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _generateQuestions,
                    child: const Text('Generate'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
              const SizedBox(height: 16),
              if (loading) const LinearProgressIndicator(),
              if (generatedQuestions.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      generatedQuestions,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
