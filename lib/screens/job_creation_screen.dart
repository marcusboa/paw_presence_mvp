import 'package:flutter/material.dart';
import '../models/job_creation.dart';
import '../services/job_creation_service.dart';
import '../services/pet_owner_demo_data_service.dart';
import '../widgets/custom_app_bar.dart';

class JobCreationScreen extends StatefulWidget {
  const JobCreationScreen({super.key});

  @override
  State<JobCreationScreen> createState() => _JobCreationScreenState();
}

class _JobCreationScreenState extends State<JobCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _specialInstructionsController = TextEditingController();
  final _addressController = TextEditingController();
  
  List<String> _selectedPetIds = [];
  String _selectedServiceType = ServiceType.petSitting;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  List<DailyTask> _dailyTasks = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeDefaultTasks();
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initializeDefaultTasks() {
    _dailyTasks = [
      DailyTask(
        id: 'task_1',
        title: 'Morning Feeding',
        description: 'Feed pets their morning meal',
        time: const TimeOfDay(hour: 8, minute: 0),
        category: TaskCategory.feeding,
      ),
      DailyTask(
        id: 'task_2',
        title: 'Evening Feeding',
        description: 'Feed pets their evening meal',
        time: const TimeOfDay(hour: 18, minute: 0),
        category: TaskCategory.feeding,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Book a Sitter',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Select Your Pets', Icons.pets),
                _buildPetSelectionSection(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Service Details', Icons.work_outline),
                _buildServiceDetailsSection(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Schedule', Icons.calendar_today),
                _buildScheduleSection(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Daily Tasks', Icons.list_alt),
                _buildDailyTasksSection(),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Special Instructions', Icons.note),
                _buildSpecialInstructionsSection(),
                
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        const Divider(thickness: 1, color: Colors.deepPurple),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPetSelectionSection() {
    final pets = PetOwnerDemoDataService.getPets();
    
    return Column(
      children: pets.map((pet) {
        final petId = pet['id'].toString();
        final isSelected = _selectedPetIds.contains(petId);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedPetIds.add(petId);
                } else {
                  _selectedPetIds.remove(petId);
                }
              });
            },
            title: Text(pet['name']),
            subtitle: Text('${pet['breed']} • ${pet['age']} years old'),
            secondary: CircleAvatar(
              backgroundImage: AssetImage(pet['imageUrl']),
            ),
            activeColor: Colors.deepPurple,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServiceDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedServiceType,
          decoration: const InputDecoration(
            labelText: 'Service Type',
            border: OutlineInputBorder(),
          ),
          items: ServiceType.all.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type),
                  Text(
                    ServiceType.getDescription(type),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedServiceType = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Service Address',
            hintText: 'Where should the sitter come?',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the service address';
            }
            return null;
          },
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(_formatDate(_startDate)),
                  leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  onTap: () => _selectDate(context, true),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                child: ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(_formatDate(_endDate)),
                  leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.deepPurple.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Duration: ${_endDate.difference(_startDate).inDays + 1} days',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyTasksSection() {
    return Column(
      children: [
        ..._dailyTasks.map((task) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(
              TaskCategory.getIcon(task.category),
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(task.title),
            subtitle: Text('${task.displayTime} • ${task.description}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _dailyTasks.remove(task);
                });
              },
            ),
          ),
        )),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addNewTask,
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialInstructionsSection() {
    return TextFormField(
      controller: _specialInstructionsController,
      decoration: const InputDecoration(
        labelText: 'Special Instructions',
        hintText: 'Any special care instructions, feeding schedules, medications, etc.',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
    );
  }

  Widget _buildSubmitButton() {
    final estimatedCost = JobCreationService.calculateEstimatedCost(
      JobCreation(
        id: 'temp',
        selectedPetIds: _selectedPetIds,
        specialInstructions: _specialInstructionsController.text,
        address: _addressController.text,
        startDate: _startDate,
        endDate: _endDate,
        dailyTasks: _dailyTasks,
        serviceType: _selectedServiceType,
        createdAt: DateTime.now(),
      ),
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated Cost:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${estimatedCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitJob,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Submitting...'),
                    ],
                  )
                : const Text(
                    'Submit Job Request',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is after start date
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) => _TaskCreationDialog(
        onTaskCreated: (task) {
          setState(() {
            _dailyTasks.add(task);
          });
        },
      ),
    );
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPetIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one pet')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final job = JobCreation(
        id: 'job_${DateTime.now().millisecondsSinceEpoch}',
        selectedPetIds: _selectedPetIds,
        specialInstructions: _specialInstructionsController.text,
        address: _addressController.text,
        startDate: _startDate,
        endDate: _endDate,
        dailyTasks: _dailyTasks,
        serviceType: _selectedServiceType,
        createdAt: DateTime.now(),
      );

      final success = await JobCreationService.submitJob(job);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting job: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TaskCreationDialog extends StatefulWidget {
  final Function(DailyTask) onTaskCreated;

  const _TaskCreationDialog({required this.onTaskCreated});

  @override
  State<_TaskCreationDialog> createState() => _TaskCreationDialogState();
}

class _TaskCreationDialogState extends State<_TaskCreationDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = TaskCategory.feeding;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: TaskCategory.all.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Text(TaskCategory.getIcon(category)),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(_selectedTime.format(context)),
              leading: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final task = DailyTask(
                id: 'task_${DateTime.now().millisecondsSinceEpoch}',
                title: _titleController.text,
                description: _descriptionController.text,
                time: _selectedTime,
                category: _selectedCategory,
              );
              widget.onTaskCreated(task);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
