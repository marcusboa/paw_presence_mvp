import 'package:flutter/material.dart';
import '../services/pet_owner_demo_data_service.dart';
import '../services/image_service.dart';
import '../widgets/loading_widgets.dart';
import '../widgets/custom_app_bar.dart';

/// Comprehensive Pet Information Screen for Pet Owners
/// Displays detailed pet information with edit functionality
class PetInfoScreen extends StatefulWidget {
  final String petId;
  
  const PetInfoScreen({
    super.key,
    required this.petId,
  });

  @override
  State<PetInfoScreen> createState() => _PetInfoScreenState();
}

class _PetInfoScreenState extends State<PetInfoScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? _petData;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _editController;
  late Animation<double> _fadeAnimation;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _descriptionController;
  late TextEditingController _medicalNotesController;
  late TextEditingController _careInstructionsController;
  late TextEditingController _emergencyContactController;
  
  String _selectedType = 'Dog';
  final List<String> _petTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _editController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    // Initialize form controllers
    _nameController = TextEditingController();
    _breedController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _descriptionController = TextEditingController();
    _medicalNotesController = TextEditingController();
    _careInstructionsController = TextEditingController();
    _emergencyContactController = TextEditingController();
    
    _loadPetData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _editController.dispose();
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();
    _medicalNotesController.dispose();
    _careInstructionsController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  Future<void> _loadPetData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      final pet = PetOwnerDemoDataService.getPetById(widget.petId);
      if (pet != null) {
        setState(() {
          _petData = pet;
          _populateFormFields();
          _isLoading = false;
        });
        _fadeController.forward();
      } else {
        // Handle pet not found
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _populateFormFields() {
    if (_petData != null) {
      _nameController.text = _petData!['name'] ?? '';
      _breedController.text = _petData!['breed'] ?? '';
      _ageController.text = _petData!['age']?.toString() ?? '';
      _weightController.text = _petData!['weight'] ?? '';
      _descriptionController.text = _petData!['description'] ?? '';
      _medicalNotesController.text = _petData!['medicalNotes'] ?? '';
      _careInstructionsController.text = _petData!['careInstructions'] ?? '';
      _emergencyContactController.text = _petData!['emergencyContact'] ?? '';
      _selectedType = _petData!['type'] ?? 'Dog';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: _petData?.isNotEmpty == true ? _petData!['name'] : 'Pet Info',
        actions: [
          if (!_isLoading && _petData != null) ...[
            if (_isEditing) ...[
              TextButton(
                onPressed: _cancelEdit,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save'),
              ),
            ] else ...[
              IconButton(
                onPressed: _startEdit,
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Pet Info',
              ),
            ],
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Pet image skeleton
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 24),
          
          // Pet name skeleton
          Container(
            height: 32,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          
          // Pet details skeleton
          Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 32),
          
          // Info cards skeleton
          for (int i = 0; i < 4; i++) ...[
            LoadingWidgets.shimmerListItem(height: 120),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_petData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Pet not found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested pet information could not be loaded.',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPetHeader(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 16),
              _buildDescriptionSection(),
              const SizedBox(height: 16),
              _buildMedicalSection(),
              const SizedBox(height: 16),
              _buildCareInstructionsSection(),
              const SizedBox(height: 16),
              _buildEmergencyContactSection(),
              const SizedBox(height: 16),
              _buildInsuranceInfoSection(),
              const SizedBox(height: 16),
              _buildBookingHistorySection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetHeader() {
    return Column(
      children: [
        // Pet Image
        Stack(
          children: [
            ImageService.petAvatar(
              petName: _petData!['name'],
              imageUrl: _petData!['imageUrl'],
              radius: 60,
            ),
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    onPressed: _changePhoto,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Pet Name and Status
        if (_isEditing)
          TextFormField(
            controller: _nameController,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Pet Name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Pet name is required';
              }
              return null;
            },
          )
        else
          Text(
            _petData!['name'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _petData!['isActive'] ? Colors.green.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _petData!['isActive'] ? 'Active Pet' : 'Past Pet',
            style: TextStyle(
              color: _petData!['isActive'] ? Colors.green.shade700 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildInfoCard(
      title: 'Basic Information',
      icon: Icons.info_outline,
      child: Column(
        children: [
          if (_isEditing) ...[
            // Pet Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Pet Type',
                border: OutlineInputBorder(),
              ),
              items: _petTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Breed
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Breed',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Breed is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Age and Weight Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age (years)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Age is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Enter a valid age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Weight is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildInfoRow('Type', _petData!['type']),
            _buildInfoRow('Breed', _petData!['breed']),
            _buildInfoRow('Age', '${_petData!['age']} years old'),
            _buildInfoRow('Weight', _petData!['weight']),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildInfoCard(
      title: 'Description',
      icon: Icons.description_outlined,
      child: _isEditing
          ? TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Pet Description',
                hintText: 'Describe your pet\'s personality and characteristics...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            )
          : Text(
              _petData!['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
    );
  }

  Widget _buildMedicalSection() {
    return _buildInfoCard(
      title: 'Medical Information',
      icon: Icons.medical_services_outlined,
      child: _isEditing
          ? TextFormField(
              controller: _medicalNotesController,
              decoration: const InputDecoration(
                labelText: 'Medical Notes',
                hintText: 'Vaccinations, medications, health conditions...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            )
          : Text(
              _petData!['medicalNotes'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
    );
  }

  Widget _buildCareInstructionsSection() {
    return _buildInfoCard(
      title: 'Care Instructions',
      icon: Icons.pets,
      child: _isEditing
          ? TextFormField(
              controller: _careInstructionsController,
              decoration: const InputDecoration(
                labelText: 'Care Instructions',
                hintText: 'Feeding schedule, exercise needs, special requirements...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            )
          : Text(
              _petData!['careInstructions'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildInfoCard(
      title: 'Emergency Contact',
      icon: Icons.emergency,
      child: _isEditing
          ? TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact',
                hintText: 'Veterinarian contact information...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Emergency contact is required';
                }
                return null;
              },
            )
          : Row(
              children: [
                Icon(Icons.phone, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _petData!['emergencyContact'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _callEmergencyContact,
                  icon: Icon(Icons.call, color: Colors.red.shade600),
                  tooltip: 'Call Emergency Contact',
                ),
              ],
            ),
    );
  }

  Widget _buildInsuranceInfoSection() {
    final insuranceInfo = _petData!['insuranceInfo'];
    if (insuranceInfo == null) {
      return _buildInfoCard(
        title: 'Insurance Information',
        icon: Icons.security,
        child: Text(
          'No insurance information available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return _buildInfoCard(
      title: 'Insurance Information',
      icon: Icons.security,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Provider', insuranceInfo['provider']),
          const SizedBox(height: 8),
          _buildInfoRow('Policy Number', insuranceInfo['policyNumber']),
          const SizedBox(height: 8),
          _buildInfoRow('Member ID', insuranceInfo['memberID']),
          const SizedBox(height: 8),
          _buildInfoRow('Coverage Type', insuranceInfo['coverageType']),
          const SizedBox(height: 8),
          _buildInfoRow('Deductible', insuranceInfo['deductible']),
          const SizedBox(height: 8),
          _buildInfoRow('Coverage Limit', insuranceInfo['coverageLimit']),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.blue.shade700, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  insuranceInfo['emergencyContact'],
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.blue.shade700, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Claims',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  insuranceInfo['claimSubmission'],
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.amber.shade700, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Important Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  insuranceInfo['preAuthRequired'],
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  insuranceInfo['notes'],
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistorySection() {
    return _buildInfoCard(
      title: 'Booking History',
      icon: Icons.history,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Last Booking', _formatDate(_petData!['lastBooking'])),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _viewBookingHistory,
                  icon: const Icon(Icons.list_alt),
                  label: const Text('View All Bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    foregroundColor: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _bookNewService,
                  icon: const Icon(Icons.add),
                  label: const Text('Book Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startEdit() {
    setState(() {
      _isEditing = true;
    });
    _editController.forward();
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    _editController.reverse();
    _populateFormFields(); // Reset form fields
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate saving delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Update pet data
      setState(() {
        _petData!['name'] = _nameController.text.trim();
        _petData!['type'] = _selectedType;
        _petData!['breed'] = _breedController.text.trim();
        _petData!['age'] = int.parse(_ageController.text.trim());
        _petData!['weight'] = _weightController.text.trim();
        _petData!['description'] = _descriptionController.text.trim();
        _petData!['medicalNotes'] = _medicalNotesController.text.trim();
        _petData!['careInstructions'] = _careInstructionsController.text.trim();
        _petData!['emergencyContact'] = _emergencyContactController.text.trim();
        _isEditing = false;
        _isSaving = false;
      });

      _editController.reverse();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('${_petData!['name']}\'s information updated successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _changePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo update feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _callEmergencyContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${_petData!['emergencyContact']}...'),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewBookingHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking history feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _bookNewService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New booking feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
