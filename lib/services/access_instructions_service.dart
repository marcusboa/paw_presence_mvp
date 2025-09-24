import 'package:flutter/material.dart';

class AccessInstructions {
  final int id;
  final String buildingName;
  final String address;
  final List<AccessStep> entrySteps;
  final List<AccessStep> exitSteps;
  final List<String> keysRequired;
  final List<String> securityNotes;
  final List<String> parkingInstructions;
  final bool hasGateCode;
  final String? gateCode;
  final bool hasLockbox;
  final String? lockboxLocation;
  final String? lockboxCode;
  final List<String> images;
  final String? contactName;
  final String? contactPhone;
  final bool hasSecurityCamera;
  
  const AccessInstructions({
    required this.id,
    required this.buildingName,
    required this.address,
    required this.entrySteps,
    required this.exitSteps,
    this.keysRequired = const [],
    this.securityNotes = const [],
    this.parkingInstructions = const [],
    this.hasGateCode = false,
    this.gateCode,
    this.hasLockbox = false,
    this.lockboxLocation,
    this.lockboxCode,
    this.images = const [],
    this.contactName,
    this.contactPhone,
    this.hasSecurityCamera = false,
  });
}

class AccessStep {
  final int order;
  final String instruction;
  final String? imageUrl;
  final bool isImportant;
  final String? note;
  
  const AccessStep({
    required this.order,
    required this.instruction,
    this.imageUrl,
    this.isImportant = false,
    this.note,
  });
}

class AccessInstructionsService {
  // Get access instructions for a given job
  static AccessInstructions getAccessInstructions(int jobId) {
    // In a real app, this would fetch data from a database or API based on the job ID
    return AccessInstructions(
      id: 1,
      buildingName: "Riverside Towers",
      address: "123 Main Street, Apt 4B, Anytown, USA 12345",
      hasGateCode: true,
      gateCode: "4321#",
      hasLockbox: true,
      lockboxLocation: "Mounted on the right side of the gate, hidden behind the small plant",
      lockboxCode: "1234",
      keysRequired: ["Building FOB", "Apartment key", "Mailbox key"],
      entrySteps: [
        const AccessStep(
          order: 1,
          instruction: "Park in visitor parking spot #12 or street parking on Oak Avenue",
          isImportant: true,
        ),
        const AccessStep(
          order: 2,
          instruction: "Walk to the main gate on the south side of the building",
          note: "Do not use the north entrance as it requires a resident card that you won't have",
        ),
        const AccessStep(
          order: 3,
          instruction: "Enter gate code 4321# on the keypad",
          isImportant: true,
        ),
        const AccessStep(
          order: 4,
          instruction: "Take the elevator on the right to the 4th floor",
        ),
        const AccessStep(
          order: 5,
          instruction: "Turn left out of the elevator and go to the end of the hallway",
        ),
        const AccessStep(
          order: 6,
          instruction: "Apartment 4B is on the right side at the end of the hallway",
        ),
        const AccessStep(
          order: 7,
          instruction: "Use the apartment key to unlock the deadbolt first, then the doorknob lock",
          isImportant: true,
          note: "The deadbolt is sticky. You may need to jiggle it slightly while turning.",
        ),
      ],
      exitSteps: [
        const AccessStep(
          order: 1,
          instruction: "Make sure to lock both the doorknob and deadbolt when leaving",
          isImportant: true,
        ),
        const AccessStep(
          order: 2,
          instruction: "Return the key to the lockbox and scramble the code",
          isImportant: true,
        ),
        const AccessStep(
          order: 3,
          instruction: "The gate will unlock automatically when exiting",
        ),
      ],
      securityNotes: [
        "The building has security cameras in all common areas",
        "If you encounter any issues, contact the building manager at (555) 765-4321",
      ],
      parkingInstructions: [
        "Park only in visitor spot #12 or on Oak Avenue",
        "Do not block the garage entrance",
        "Parking in resident spaces will result in towing",
      ],
      hasSecurityCamera: true,
      contactName: "Building Manager: Mike Wilson",
      contactPhone: "(555) 765-4321",
      images: [],
    );
  }
}

// Widget to display access instructions
class AccessInstructionsView extends StatelessWidget {
  final AccessInstructions instructions;
  final bool isReadOnly;
  
  const AccessInstructionsView({
    super.key,
    required this.instructions,
    this.isReadOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Building information
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.apartment, size: 24, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        instructions.buildingName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (instructions.hasSecurityCamera)
                      Tooltip(
                        message: 'Security cameras present',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.videocam,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        instructions.address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                if (instructions.contactName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.contact_phone, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${instructions.contactName} - ${instructions.contactPhone}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        // Keys and access codes
        if (instructions.keysRequired.isNotEmpty ||
            instructions.hasGateCode ||
            instructions.hasLockbox)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Access Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (instructions.keysRequired.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.key, size: 18, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        const Text(
                          'Keys Required:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ...instructions.keysRequired.map(
                      (key) => Padding(
                        padding: const EdgeInsets.only(left: 26, bottom: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 6, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(key),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (instructions.hasGateCode) ...[
                    Row(
                      children: [
                        const Icon(Icons.password, size: 18, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        const Text(
                          'Gate Code:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            instructions.gateCode ?? '',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (instructions.hasLockbox) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock, size: 18, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Lockbox:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    if (instructions.lockboxLocation != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 26, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Location: '),
                            Expanded(child: Text(instructions.lockboxLocation!)),
                          ],
                        ),
                      ),
                    if (instructions.lockboxCode != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 26, top: 4),
                        child: Row(
                          children: [
                            const Text('Code: '),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                instructions.lockboxCode ?? '',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),

        // Entry instructions
        const Text(
          'Entry Instructions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: instructions.entrySteps.length,
          itemBuilder: (context, index) {
            final step = instructions.entrySteps[index];
            return _buildStepItem(step);
          },
        ),

        const SizedBox(height: 16),

        // Exit instructions
        const Text(
          'Exit Instructions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: instructions.exitSteps.length,
          itemBuilder: (context, index) {
            final step = instructions.exitSteps[index];
            return _buildStepItem(step);
          },
        ),

        // Security notes
        if (instructions.securityNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.blue.shade50,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Security Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...instructions.securityNotes.map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(note)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Parking instructions
        if (instructions.parkingInstructions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.amber.shade50,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_parking, size: 18, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Parking Instructions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...instructions.parkingInstructions.map(
                    (instruction) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(instruction)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStepItem(AccessStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: step.isImportant ? Colors.amber.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: step.isImportant ? Colors.amber : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${step.order}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isImportant ? Colors.black : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.instruction,
                          style: TextStyle(
                            fontWeight: step.isImportant ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (step.isImportant)
                        const Icon(
                          Icons.priority_high,
                          size: 16,
                          color: Colors.amber,
                        ),
                    ],
                  ),
                  if (step.note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      step.note!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
