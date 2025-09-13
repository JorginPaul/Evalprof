import 'package:flutter/material.dart';

class NewCorrectionScreen extends StatefulWidget {
  const NewCorrectionScreen({super.key});

  @override
  State<NewCorrectionScreen> createState() => _NewCorrectionScreenState();
}

class _NewCorrectionScreenState extends State<NewCorrectionScreen> {
  final _form = GlobalKey<FormState>();
  String evaluationId = '';
  String answerKey = '';
  String? notes;

  void _save() async {
    if (!_form.currentState!.validate()) return;
    await Future.delayed(const Duration(milliseconds: 600)); // simulate
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Correction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Evaluation ID'),
                onChanged: (v) => evaluationId = v,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter evaluation id' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Answer Key'),
                onChanged: (v) => answerKey = v,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter answer key' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                minLines: 2,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                onChanged: (v) => notes = v,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
