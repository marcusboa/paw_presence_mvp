import 'dart:io';
import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../services/receipt_service.dart';
import '../widgets/loading_widgets.dart';

class EndOfJobReceiptDeliveryScreen extends StatefulWidget {
  final String jobId;
  final String petOwnerName;
  final String petName;

  const EndOfJobReceiptDeliveryScreen({
    super.key,
    required this.jobId,
    required this.petOwnerName,
    required this.petName,
  });

  @override
  State<EndOfJobReceiptDeliveryScreen> createState() => _EndOfJobReceiptDeliveryScreenState();
}

class _EndOfJobReceiptDeliveryScreenState extends State<EndOfJobReceiptDeliveryScreen> {
  bool _isLoading = true;
  List<Receipt> _filedReceipts = [];
  final Set<String> _selectedReceipts = {};

  @override
  void initState() {
    super.initState();
    _loadFiledReceipts();
  }

  Future<void> _loadFiledReceipts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final allReceipts = ReceiptService.getAllReceipts();
    final filedReceipts = allReceipts
        .where((receipt) => 
            receipt.jobId == widget.jobId && 
            receipt.status == ReceiptStatus.filed)
        .toList();

    if (mounted) {
      setState(() {
        _filedReceipts = filedReceipts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End-of-Job Receipt Delivery'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          if (_selectedReceipts.isNotEmpty)
            TextButton(
              onPressed: _deliverSelectedReceipts,
              child: Text(
                'Deliver (${_selectedReceipts.length})',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                _buildJobHeader(),
                _buildInstructions(),
                Expanded(child: _buildReceiptsList()),
                if (_selectedReceipts.isNotEmpty) _buildDeliveryActions(),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            LoadingWidgets.shimmerListItem(),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildJobHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade200,
            child: Text(
              widget.petOwnerName[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.petOwnerName} • ${widget.petName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Job completed - Ready to deliver receipts',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Job Complete',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Select receipts to deliver to ${widget.petOwnerName} now that the job is complete.',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptsList() {
    if (_filedReceipts.isEmpty) {
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
              'No filed receipts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All receipts for this job have been delivered',
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filedReceipts.length,
      itemBuilder: (context, index) {
        final receipt = _filedReceipts[index];
        final isSelected = _selectedReceipts.contains(receipt.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedReceipts.add(receipt.id);
                } else {
                  _selectedReceipts.remove(receipt.id);
                }
              });
            },
            secondary: Container(
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
            title: Text(
              receipt.description,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                if (receipt.amount != null)
                  Text(
                    '\$${receipt.amount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(receipt.dateTime),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                if (receipt.notes != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    receipt.notes!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.deepPurple,
          ),
        );
      },
    );
  }

  Widget _buildDeliveryActions() {
    final totalAmount = _filedReceipts
        .where((receipt) => _selectedReceipts.contains(receipt.id))
        .fold<double>(0.0, (sum, receipt) => sum + (receipt.amount ?? 0.0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedReceipts.length} receipts selected',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (totalAmount > 0)
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green.shade700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedReceipts.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Selection'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _deliverSelectedReceipts,
                  icon: const Icon(Icons.send),
                  label: const Text('Deliver Receipts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
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

  void _deliverSelectedReceipts() {
    if (_selectedReceipts.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deliver Receipts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Deliver ${_selectedReceipts.length} receipts to ${widget.petOwnerName}?',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'This will send all selected receipts via message and mark them as delivered.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performDelivery();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Deliver'),
            ),
          ],
        );
      },
    );
  }

  void _performDelivery() {
    // Mark selected receipts as delivered
    for (final receiptId in _selectedReceipts) {
      ReceiptService.markReceiptAsDelivered(receiptId);
    }

    final deliveredCount = _selectedReceipts.length;
    
    // Remove delivered receipts from the list
    setState(() {
      _filedReceipts.removeWhere((receipt) => _selectedReceipts.contains(receipt.id));
      _selectedReceipts.clear();
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('$deliveredCount receipts delivered to ${widget.petOwnerName}'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    // If no more receipts, show completion dialog
    if (_filedReceipts.isEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        _showJobCompletionDialog();
      });
    }
  }

  void _showJobCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Text('Job Complete!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All receipts have been delivered to ${widget.petOwnerName}.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'The job is now fully complete with all expenses documented and shared.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
