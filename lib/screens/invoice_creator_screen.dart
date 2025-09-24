import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/invoice_generator.dart';
import '../widgets/custom_app_bar.dart';

class InvoiceCreatorScreen extends StatefulWidget {
  const InvoiceCreatorScreen({super.key});

  @override
  State<InvoiceCreatorScreen> createState() => _InvoiceCreatorScreenState();
}

class _InvoiceCreatorScreenState extends State<InvoiceCreatorScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Pet Sitter Details
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactDetailsController = TextEditingController();
  final _abnController = TextEditingController();
  
  // Controllers for Recipient Details
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _referenceNumberController = TextEditingController();
  
  // Controllers for Invoice Information
  final _invoiceNumberController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _paymentMethodsController = TextEditingController();
  final _bankingInfoController = TextEditingController();
  final _personalMessageController = TextEditingController();
  
  // Invoice dates
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));
  
  // List of services/items
  final List<InvoiceItemEntry> _items = [InvoiceItemEntry()];
  
  // Tax rate (10% GST for Australia)
  final double _taxRate = 0.10;
  
  @override
  void dispose() {
    // Dispose of all controllers
    _businessNameController.dispose();
    _addressController.dispose();
    _contactDetailsController.dispose();
    _abnController.dispose();
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _contactPersonController.dispose();
    _referenceNumberController.dispose();
    _invoiceNumberController.dispose();
    _paymentTermsController.dispose();
    _paymentMethodsController.dispose();
    _bankingInfoController.dispose();
    _personalMessageController.dispose();
    for (var item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  // Calculate subtotal
  double get subtotal {
    double sum = 0;
    for (var item in _items) {
      sum += item.total;
    }
    return sum;
  }
  
  // Calculate tax amount
  double get taxAmount {
    return subtotal * _taxRate;
  }
  
  // Calculate total
  double get total {
    return subtotal + taxAmount;
  }
  
  // Format as currency
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Create Invoice',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Pet Sitter Details', Icons.person),
              _buildPetSitterDetailsSection(),
              
              _buildSectionHeader('Recipient Details', Icons.people),
              _buildRecipientDetailsSection(),
              
              _buildSectionHeader('Invoice Information', Icons.receipt_long),
              _buildInvoiceInfoSection(),
              
              _buildSectionHeader('Itemized List', Icons.list_alt),
              ..._buildItemizedListSection(),
              
              _buildSectionHeader('Payment Details', Icons.payment),
              _buildPaymentDetailsSection(),
              
              _buildSectionHeader('Personal Message', Icons.message),
              _buildPersonalMessageSection(),
              
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Convert form data to an Invoice object
                      final List<InvoiceItem> invoiceItems = [];
                      
                      // Convert our form items to InvoiceItem objects
                      for (var item in _items) {
                        invoiceItems.add(InvoiceItem(
                          description: item.descriptionController.text,
                          quantity: int.parse(item.quantityController.text),
                          unitPrice: double.parse(item.unitPriceController.text),
                          tax: _taxRate,
                        ));
                      }
                      
                      // Create the invoice object
                      final invoice = Invoice(
                        id: _invoiceNumberController.text.isNotEmpty ? 
                             _invoiceNumberController.text : 'INV-${DateTime.now().millisecondsSinceEpoch}',
                        clientName: _customerNameController.text,
                        clientEmail: '', // Not collected in our form, could add later
                        clientAddress: _customerAddressController.text,
                        issueDate: _invoiceDate,
                        dueDate: _dueDate,
                        petName: '', // Not collected in our form, could add later
                        serviceType: 'Pet Sitting Services',
                        items: invoiceItems,
                        notes: _personalMessageController.text,
                      );
                      
                      // Add the invoice to the invoice generator's recent invoices list
                      InvoiceGenerator.addInvoice(invoice);
                      
                      // Show success message and navigate back to invoice screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invoice created successfully')),
                      );
                      
                      // Return to previous screen after short delay
                      Future.delayed(const Duration(seconds: 1), () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate Invoice PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
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
      ],
    );
  }
  
  Widget _buildPetSitterDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _businessNameController,
          decoration: const InputDecoration(
            labelText: 'Business/Personal Name',
            hintText: 'e.g., Sally\'s Pet Sitting Services',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a business name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'e.g., 123 Pet Lane, Sydney NSW 2000',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an address';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contactDetailsController,
          decoration: const InputDecoration(
            labelText: 'Contact Details',
            hintText: 'e.g., 0400 123 456 | sally@petsitting.com',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter contact details';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _abnController,
          decoration: const InputDecoration(
            labelText: 'Australian Business Number (ABN)',
            hintText: 'e.g., 12 345 678 901',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }
  
  Widget _buildRecipientDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _customerNameController,
          decoration: const InputDecoration(
            labelText: 'Customer\'s Name',
            hintText: 'e.g., John Smith',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a customer name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _customerAddressController,
          decoration: const InputDecoration(
            labelText: 'Customer\'s Address',
            hintText: 'e.g., 456 Dog Street, Melbourne VIC 3000',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a customer address';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contactPersonController,
          decoration: const InputDecoration(
            labelText: 'Name of Contact Person',
            hintText: 'e.g., Jane Smith',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _referenceNumberController,
          decoration: const InputDecoration(
            labelText: 'Purchase Order or Reference Number',
            hintText: 'e.g., PO-12345',
          ),
        ),
      ],
    );
  }
  
  Widget _buildInvoiceInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _invoiceNumberController,
          decoration: const InputDecoration(
            labelText: 'Invoice Number',
            hintText: 'e.g., INV-2025-0001',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an invoice number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Invoice Date'),
                subtitle: Text(_formatDate(_invoiceDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Payment Due Date'),
                subtitle: Text(_formatDate(_dueDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildItemizedListSection() {
    List<Widget> itemWidgets = [];
    
    for (int i = 0; i < _items.length; i++) {
      itemWidgets.add(
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Item #${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (_items.length > 1)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _items[i].dispose();
                            _items.removeAt(i);
                          });
                        },
                      ),
                  ],
                ),
                TextFormField(
                  controller: _items[i].descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g., Dog Walking Services',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _items[i].quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'e.g., 5',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() {}); // Update totals
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _items[i].unitPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Unit Price (\$)',
                          hintText: 'e.g., 25.00',
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() {}); // Update totals
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text('Item Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        formatCurrency(_items[i].total),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    itemWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _items.add(InvoiceItemEntry());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade100,
            foregroundColor: Colors.deepPurple,
          ),
        ),
      ),
    );
    
    // Totals section
    itemWidgets.add(
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.deepPurple.shade50,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(formatCurrency(subtotal)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax (${(_taxRate * 100).toStringAsFixed(1)}%):', 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(formatCurrency(taxAmount)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL:', 
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(
                    formatCurrency(total),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
    return itemWidgets;
  }
  
  Widget _buildPaymentDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _paymentTermsController,
          decoration: const InputDecoration(
            labelText: 'Payment Terms',
            hintText: 'e.g., Payment due within 14 days of invoice date',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _paymentMethodsController,
          decoration: const InputDecoration(
            labelText: 'Accepted Payment Methods',
            hintText: 'e.g., Bank Transfer, PayPal, Credit Card',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _bankingInfoController,
          decoration: const InputDecoration(
            labelText: 'Banking Information',
            hintText: 'e.g., BSB: 123-456, Account: 12345678, Bank: ABC Bank',
          ),
          maxLines: 2,
        ),
      ],
    );
  }
  
  Widget _buildPersonalMessageSection() {
    return TextFormField(
      controller: _personalMessageController,
      decoration: const InputDecoration(
        labelText: 'Personal Message',
        hintText: 'e.g., Thank you for choosing our pet sitting services!',
      ),
      maxLines: 3,
    );
  }
  
  // Date picker
  Future<void> _selectDate(BuildContext context, bool isInvoiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        if (isInvoiceDate) {
          _invoiceDate = picked;
          // Update due date to be 14 days from new invoice date
          _dueDate = _invoiceDate.add(const Duration(days: 14));
        } else {
          _dueDate = picked;
        }
      });
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Class for invoice items
class InvoiceItemEntry {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: '1');
  final TextEditingController unitPriceController = TextEditingController(text: '0.00');
  
  // Calculate item total
  double get total {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double unitPrice = double.tryParse(unitPriceController.text) ?? 0;
    return quantity * unitPrice;
  }
  
  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
  }
}
