import 'package:flutter/material.dart';
import '../services/invoice_generator.dart';
import 'invoice_creator_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Invoice _currentInvoice;
  late Invoice _pastInvoice;
  bool _isLoading = true;
  List<Invoice> _recentInvoices = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load data
    _loadInvoices();
  }
  
  void _loadInvoices() {
    // Short delay for UI responsiveness
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        // Check for any newly created invoices first
        _recentInvoices = InvoiceGenerator.getRecentInvoices();
        
        if (_recentInvoices.isNotEmpty) {
          // Use the most recent created invoice as current
          _currentInvoice = _recentInvoices[0];
          _pastInvoice = InvoiceGenerator.generateHistoricalInvoice();
        } else {
          // Fall back to sample invoices if none created
          _currentInvoice = InvoiceGenerator.generateSampleInvoice();
          _pastInvoice = InvoiceGenerator.generateHistoricalInvoice();
        }
        
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload invoices when returning to this screen
    _loadInvoices();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'History'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InvoiceCreatorScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create New'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Current invoice tab
                SingleChildScrollView(
                  child: InvoicePreview(
                    invoice: _currentInvoice,
                    onPay: () => _showPaymentDialog(),
                    onDownload: () => _showFeatureSnackbar('Download'),
                    onShare: () => _showFeatureSnackbar('Share'),
                  ),
                ),
                
                // Historical invoices tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      InvoicePreview(
                        invoice: _pastInvoice,
                        onDownload: () => _showFeatureSnackbar('Download'),
                        onShare: () => _showFeatureSnackbar('Share'),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No more previous invoices to display.'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureSnackbar('Credit Card Payment');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Transfer'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureSnackbar('Bank Transfer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('PayPal'),
              onTap: () {
                Navigator.pop(context);
                _showFeatureSnackbar('PayPal');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFeatureSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature is for display only')),
    );
  }
}
