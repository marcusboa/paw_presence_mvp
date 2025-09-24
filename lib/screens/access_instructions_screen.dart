import 'package:flutter/material.dart';
import '../services/access_instructions_service.dart';
import '../widgets/custom_app_bar.dart';

class AccessInstructionsScreen extends StatelessWidget {
  final int jobId;

  const AccessInstructionsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    // Get the access instructions for this job
    final accessInstructions = AccessInstructionsService.getAccessInstructions(jobId);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Access Instructions',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Display-only, show a message that this is display-only
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Editing instructions is display-only'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Building Access Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Access instructions widget
            AccessInstructionsView(
              instructions: accessInstructions,
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Display-only feature
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing instructions is display-only'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Display-only feature
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download feature is display-only'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
