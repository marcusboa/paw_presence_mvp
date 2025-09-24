import 'package:flutter/material.dart';

// Model classes for invoice generation
class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double tax;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.tax = 0.0,
  });

  double get total => quantity * unitPrice;
  double get taxAmount => total * (tax / 100);
  double get totalWithTax => total + taxAmount;
}

class Invoice {
  final String id;
  final String clientName;
  final String clientEmail;
  final String clientAddress;
  final DateTime issueDate;
  final DateTime dueDate;
  final String petName;
  final String serviceType;
  final List<InvoiceItem> items;
  final String notes;
  final bool isPaid;
  final String paymentMethod;

  Invoice({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientAddress,
    required this.issueDate,
    required this.dueDate,
    required this.petName,
    required this.serviceType,
    required this.items,
    this.notes = '',
    this.isPaid = false,
    this.paymentMethod = '',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxTotal => items.fold(0, (sum, item) => sum + item.taxAmount);
  double get total => subtotal + taxTotal;
}

class InvoiceGenerator {
  // Store recently created invoices
  static final List<Invoice> _recentInvoices = [];
  
  // Add a new invoice to the list
  static void addInvoice(Invoice invoice) {
    _recentInvoices.insert(0, invoice); // Add to beginning of list
  }
  
  // Get the most recent invoice
  static Invoice? getMostRecentInvoice() {
    return _recentInvoices.isNotEmpty ? _recentInvoices[0] : null;
  }
  
  // Get all recent invoices
  static List<Invoice> getRecentInvoices() {
    return List.from(_recentInvoices);
  }
  
  // Generate a sample invoice for display purposes
  static Invoice generateSampleInvoice() {
    return Invoice(
      id: 'INV-2025-0042',
      clientName: 'John Smith',
      clientEmail: 'john.smith@example.com',
      clientAddress: '123 Main Street, Anytown, USA 12345',
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      petName: 'Max',
      serviceType: 'Pet Sitting',
      items: [
        InvoiceItem(
          description: 'Pet Sitting (Daily Rate)',
          quantity: 5,
          unitPrice: 45.00,
        ),
        InvoiceItem(
          description: 'Extra Walk',
          quantity: 2,
          unitPrice: 15.00,
        ),
        InvoiceItem(
          description: 'Medication Administration',
          quantity: 10,
          unitPrice: 5.00,
        ),
        InvoiceItem(
          description: 'Transportation Fee',
          quantity: 1,
          unitPrice: 25.00,
        ),
      ],
      notes: 'Thank you for choosing Paw Presence for your pet care needs!',
      isPaid: false,
    );
  }

  // Generate a historical invoice for completed service
  static Invoice generateHistoricalInvoice() {
    return Invoice(
      id: 'INV-2025-0036',
      clientName: 'John Smith',
      clientEmail: 'john.smith@example.com',
      clientAddress: '123 Main Street, Anytown, USA 12345',
      issueDate: DateTime.now().subtract(const Duration(days: 30)),
      dueDate: DateTime.now().subtract(const Duration(days: 16)),
      petName: 'Max',
      serviceType: 'Dog Walking',
      items: [
        InvoiceItem(
          description: 'Dog Walking (30 min)',
          quantity: 10,
          unitPrice: 20.00,
        ),
        InvoiceItem(
          description: 'Weekend Fee',
          quantity: 2,
          unitPrice: 5.00,
        ),
      ],
      notes: 'Thank you for your business!',
      isPaid: true,
      paymentMethod: 'Credit Card',
    );
  }
}

// Widget to display invoice
class InvoicePreview extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onPay;
  
  const InvoicePreview({
    super.key,
    required this.invoice,
    this.onDownload,
    this.onShare,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    // Format dates as strings with a consistent format
    String formatDate(DateTime date) {
      return '${date.month}/${date.day}/${date.year}';
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paw Presence',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const Text(
                      'Professional Pet Care Services',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'INVOICE #${invoice.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Issued: ${formatDate(invoice.issueDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Due: ${formatDate(invoice.dueDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Client Information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BILLED TO:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.clientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(invoice.clientEmail),
                      Text(invoice.clientAddress),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SERVICE DETAILS:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pet: ${invoice.petName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Service Type: ${invoice.serviceType}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Invoice Items Table
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'QTY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'UNIT PRICE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ...invoice.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(item.description),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${item.unitPrice.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${item.total.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            )),
            const Divider(),
            
            // Totals
            Row(
              children: [
                const Spacer(flex: 7),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'SUBTOTAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '\$${invoice.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(flex: 7),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'TAX',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '\$${invoice.taxTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2, color: Colors.black),
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(flex: 7),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'TOTAL DUE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${invoice.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status and Notes
            if (invoice.isPaid)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'PAID (${invoice.paymentMethod})',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            if (invoice.notes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOTES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(invoice.notes),
                ],
              ),
              
            const SizedBox(height: 24),
            
            // Action buttons
            if (!invoice.isPaid)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onPay,
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
