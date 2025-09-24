import 'dart:io';
import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../services/receipt_service.dart';
import '../widgets/loading_widgets.dart';

class ReceiptManagementScreen extends StatefulWidget {
  const ReceiptManagementScreen({super.key});

  @override
  State<ReceiptManagementScreen> createState() => _ReceiptManagementScreenState();
}

class _ReceiptManagementScreenState extends State<ReceiptManagementScreen> with TickerProviderStateMixin {
  String _currentFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Sent', 'Filed'];
  
  bool _isLoading = true;
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
    
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    ReceiptService.initializeDemoReceipts();
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Manager'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCaptureReceiptOptions(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: Column(
                  children: [
                    _buildFilterTabs(),
                    _buildReceiptStats(),
                    Expanded(child: _buildReceiptsList()),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter tabs skeleton
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: List.generate(4, (index) => Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )),
            ),
          ),
          const SizedBox(height: 16),
          // Receipt list skeleton
          for (int i = 0; i < 5; i++) ...[
            LoadingWidgets.shimmerListItem(),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = filter == _currentFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReceiptStats() {
    final allReceipts = ReceiptService.getAllReceipts();
    final pendingCount = ReceiptService.getReceiptsByStatus(ReceiptStatus.pending).length;
    final sentCount = ReceiptService.getReceiptsByStatus(ReceiptStatus.sent).length;
    final filedCount = ReceiptService.getReceiptsByStatus(ReceiptStatus.filed).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn('${allReceipts.length}', 'Total', Colors.deepPurple),
          _buildVerticalDivider(),
          _buildStatColumn('$pendingCount', 'Pending', Colors.orange),
          _buildVerticalDivider(),
          _buildStatColumn('$sentCount', 'Sent', Colors.blue),
          _buildVerticalDivider(),
          _buildStatColumn('$filedCount', 'Filed', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildReceiptsList() {
    List<Receipt> receipts;
    
    if (_currentFilter == 'All') {
      receipts = ReceiptService.getAllReceipts();
    } else {
      final status = ReceiptStatus.values.firstWhere(
        (s) => s.displayName == _currentFilter,
        orElse: () => ReceiptStatus.pending,
      );
      receipts = ReceiptService.getReceiptsByStatus(status);
    }

    if (receipts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No receipts found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture receipts to track expenses for pet owners',
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        return _buildReceiptItem(receipt);
      },
    );
  }

  Widget _buildReceiptItem(Receipt receipt) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: receipt.imagePath.startsWith('assets/')
              ? Icon(Icons.receipt, color: Colors.grey.shade600)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(receipt.imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.receipt, color: Colors.grey.shade600);
                    },
                  ),
                ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                receipt.description,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: receipt.status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                receipt.status.displayName,
                style: TextStyle(
                  color: receipt.status.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${receipt.petOwnerName} • ${receipt.petName}'),
            const SizedBox(height: 2),
            Row(
              children: [
                if (receipt.amount != null)
                  Text(
                    '\$${receipt.amount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                const Spacer(),
                Text(
                  _formatDateTime(receipt.dateTime),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showReceiptDetails(receipt),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    _fadeController.reset();
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  void _showCaptureReceiptOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Capture Receipt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepPurple),
                title: const Text('Take Photo'),
                subtitle: const Text('Capture receipt with camera'),
                onTap: () {
                  Navigator.pop(context);
                  _captureReceiptFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.deepPurple),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select existing photo'),
                onTap: () {
                  Navigator.pop(context);
                  _captureReceiptFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _captureReceiptFromCamera() {
    _showJobSelectionDialog(true);
  }

  void _captureReceiptFromGallery() {
    _showJobSelectionDialog(false);
  }

  void _showJobSelectionDialog(bool fromCamera) {
    final activeJobs = ReceiptService.getActiveJobsForReceipts();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Job'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Which job is this receipt for?'),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: activeJobs.length,
                  itemBuilder: (context, index) {
                    final job = activeJobs[index];
                    return ListTile(
                      title: Text('${job['petOwnerName']} • ${job['petName']}'),
                      subtitle: Text(job['jobTitle']),
                      onTap: () {
                        Navigator.pop(context);
                        _captureReceiptForJob(job, fromCamera);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _captureReceiptForJob(Map<String, dynamic> job, bool fromCamera) async {
    Receipt? receipt;
    
    if (fromCamera) {
      receipt = await ReceiptService.captureReceiptPhoto(
        jobId: job['jobId'],
        petOwnerId: job['petOwnerId'],
        petOwnerName: job['petOwnerName'],
        petName: job['petName'],
      );
    } else {
      receipt = await ReceiptService.pickReceiptPhoto(
        jobId: job['jobId'],
        petOwnerId: job['petOwnerId'],
        petOwnerName: job['petOwnerName'],
        petName: job['petName'],
      );
    }

    if (receipt != null) {
      setState(() {});
      _showReceiptCapturedDialog(receipt);
    }
  }

  void _showReceiptCapturedDialog(Receipt receipt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receipt Captured!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('What would you like to do with this receipt?'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendReceiptNow(receipt);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Send Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _fileForLater(receipt);
                      },
                      icon: const Icon(Icons.folder),
                      label: const Text('File for Later'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Edit Details'),
            ),
          ],
        );
      },
    );
  }

  void _sendReceiptNow(Receipt receipt) {
    ReceiptService.sendReceiptToOwner(receipt.id);
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Receipt sent to ${receipt.petOwnerName}'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _fileForLater(Receipt receipt) {
    ReceiptService.fileReceiptForLater(receipt.id);
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.folder, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Receipt filed for end-of-job delivery'),
          ],
        ),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReceiptDetails(Receipt receipt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(receipt.description),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (receipt.amount != null)
                Text(
                  'Amount: \$${receipt.amount!.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 8),
              Text('Pet Owner: ${receipt.petOwnerName}'),
              Text('Pet: ${receipt.petName}'),
              Text('Date: ${_formatDateTime(receipt.dateTime)}'),
              Text('Status: ${receipt.status.displayName}'),
              if (receipt.notes != null) ...[
                const SizedBox(height: 8),
                Text('Notes: ${receipt.notes}'),
              ],
            ],
          ),
          actions: [
            if (receipt.status == ReceiptStatus.pending) ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendReceiptNow(receipt);
                },
                child: const Text('Send Now'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fileForLater(receipt);
                },
                child: const Text('File for Later'),
              ),
            ],
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
