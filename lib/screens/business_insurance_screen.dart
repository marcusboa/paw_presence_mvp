import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_widgets.dart';
import '../services/business_insurance_service.dart';
import '../models/business_insurance.dart';

/// Business Insurance Management Screen for Pet Sitters
/// Allows uploading and managing business insurance documents
class BusinessInsuranceScreen extends StatefulWidget {
  const BusinessInsuranceScreen({super.key});

  @override
  State<BusinessInsuranceScreen> createState() => _BusinessInsuranceScreenState();
}

class _BusinessInsuranceScreenState extends State<BusinessInsuranceScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  BusinessInsurance? _insuranceInfo;
  
  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    
    _loadInsuranceInfo();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadInsuranceInfo() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      final insurance = BusinessInsuranceService.getInsuranceInfo();
      setState(() {
        _insuranceInfo = insurance;
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Insurance',
        showBackButton: true,
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LoadingWidgets.shimmerListItem(height: 200),
          const SizedBox(height: 16),
          LoadingWidgets.shimmerListItem(height: 150),
          const SizedBox(height: 16),
          LoadingWidgets.shimmerListItem(height: 100),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInsuranceStatusCard(),
            const SizedBox(height: 24),
            _buildInsuranceDetailsCard(),
            const SizedBox(height: 24),
            _buildDocumentsCard(),
            const SizedBox(height: 24),
            _buildUploadSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceStatusCard() {
    final isActive = _insuranceInfo?.isActive ?? false;
    final expiryDate = _insuranceInfo?.expiryDate;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isActive
                ? [Colors.green.shade50, Colors.green.shade100]
                : [Colors.red.shade50, Colors.red.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.verified : Icons.warning,
                  color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Insurance Active' : 'Insurance Expired',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                      if (expiryDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          isActive 
                              ? 'Expires: ${_formatDate(expiryDate)}'
                              : 'Expired: ${_formatDate(expiryDate)}',
                          style: TextStyle(
                            color: isActive ? Colors.green.shade600 : Colors.red.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (!isActive) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please update your insurance information to continue providing services.',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceDetailsCard() {
    if (_insuranceInfo == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.security, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No Insurance Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your business insurance documents to get started.',
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Insurance Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Provider', _insuranceInfo!.provider),
            _buildDetailRow('Policy Number', _insuranceInfo!.policyNumber),
            _buildDetailRow('Coverage Amount', _insuranceInfo!.coverageAmount),
            _buildDetailRow('Effective Date', _formatDate(_insuranceInfo!.effectiveDate)),
            _buildDetailRow('Expiry Date', _formatDate(_insuranceInfo!.expiryDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
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
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard() {
    final documents = _insuranceInfo?.documents ?? [];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (documents.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.description, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'No documents uploaded',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...documents.map((doc) => _buildDocumentItem(doc)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(InsuranceDocument document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            _getDocumentIcon(document.type),
            color: Colors.deepPurple,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Uploaded: ${_formatDate(document.uploadDate)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewDocument(document),
            icon: const Icon(Icons.visibility),
            color: Colors.deepPurple,
          ),
          IconButton(
            onPressed: () => _deleteDocument(document),
            icon: const Icon(Icons.delete),
            color: Colors.red.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud_upload, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Upload Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Upload your business insurance documents to keep your profile up to date.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _uploadDocument(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _uploadDocument(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'certificate':
        return Icons.verified;
      case 'policy':
        return Icons.description;
      case 'receipt':
        return Icons.receipt;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _uploadDocument(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        // Show document type selection dialog
        final docType = await _showDocumentTypeDialog();
        if (docType != null) {
          await BusinessInsuranceService.uploadDocument(image.path, docType);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document uploaded successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          _loadInsuranceInfo(); // Refresh the data
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload document: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<String?> _showDocumentTypeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Document Type'),
          content: const Text('What type of document are you uploading?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'certificate'),
              child: const Text('Insurance Certificate'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'policy'),
              child: const Text('Policy Document'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'receipt'),
              child: const Text('Payment Receipt'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _viewDocument(InsuranceDocument document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${document.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteDocument(InsuranceDocument document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete ${document.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BusinessInsuranceService.deleteDocument(document.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
                _loadInsuranceInfo(); // Refresh the data
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
