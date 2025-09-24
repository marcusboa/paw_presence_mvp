import 'package:flutter/material.dart';
import '../widgets/loading_widgets.dart';
import '../services/image_service.dart';
import '../services/pet_owner_demo_data_service.dart';
import 'pet_info_screen.dart';

class PetsMenuScreen extends StatefulWidget {
  const PetsMenuScreen({super.key});
  
  @override
  State<PetsMenuScreen> createState() => _PetsMenuScreenState();
}

class _PetsMenuScreenState extends State<PetsMenuScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showActivePets = true;
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Pet data
  List<Map<String, dynamic>> _allPets = [];
  List<Map<String, dynamic>> get _filteredPets {
    List<Map<String, dynamic>> filtered = _allPets;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((pet) {
        final name = pet['name']?.toString().toLowerCase() ?? '';
        final breed = pet['breed']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || breed.contains(query);
      }).toList();
    }
    
    // Only show active pets
    filtered = filtered.where((pet) {
      final isActive = pet['isActive'] ?? true;
      return isActive;
    }).toList();
    
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Load pet data from demo service
    _allPets = PetOwnerDemoDataService.getPets();
    
    // Simulate loading delay for demonstration
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    _fadeController.reset();
    
    // Reload pet data
    await _loadData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Pet data refreshed'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        // Search bar skeleton
        Container(
          margin: const EdgeInsets.all(16),
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        // Filter chips skeleton
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(2, (index) => Container(
              margin: EdgeInsets.only(right: index < 1 ? 8 : 0),
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
            )),
          ),
        ),
        const SizedBox(height: 16),
        // Pet cards skeleton
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: LoadingWidgets.shimmerPetCard(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildSearchAndFilters(),
            Expanded(
              child: _buildPetsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search pets...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Filter chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Current Pets'),
                selected: _showActivePets,
                checkmarkColor: Colors.white,
                selectedColor: Colors.deepPurple,
                labelStyle: TextStyle(
                  color: _showActivePets ? Colors.white : Colors.black,
                ),
                onSelected: (selected) {
                  setState(() {
                    _showActivePets = selected;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPetsList() {
    return _filteredPets.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No pets found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters or search query',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPets.length,
            itemBuilder: (context, index) {
              final pet = _filteredPets[index];
              return _buildPetCard(pet);
            },
          );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetInfoScreen(petId: pet['id']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Enhanced Pet Image with ImageService
              ImageService.petAvatar(
                petName: pet['name'],
                imageUrl: pet['imageUrl'],
                radius: 40,
              ),
              const SizedBox(width: 16),
              // Pet Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: pet['isActive']
                                ? Colors.green.shade100
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pet['isActive'] ? 'Active' : 'Past',
                            style: TextStyle(
                              color: pet['isActive']
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet['breed']} • ${pet['age']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (pet['owner'] != null) ...[
                      Text(
                        'Owner: ${pet['owner']}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    if (pet['lastBooking'] != null) ...[
                      Text(
                        'Last booking: ${_formatDate(pet['lastBooking'])}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
