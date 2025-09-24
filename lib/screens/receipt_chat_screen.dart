import 'dart:io';
import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../services/receipt_service.dart';

class ReceiptChatScreen extends StatefulWidget {
  final Receipt receipt;
  final String conversationId;

  const ReceiptChatScreen({
    super.key,
    required this.receipt,
    required this.conversationId,
  });

  @override
  State<ReceiptChatScreen> createState() => _ReceiptChatScreenState();
}

class _ReceiptChatScreenState extends State<ReceiptChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Simulate loading existing messages
    setState(() {
      _messages.addAll([
        {
          'id': '1',
          'text': 'Hi ${widget.receipt.petOwnerName}! I have a receipt to share with you.',
          'isFromSitter': true,
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        },
        {
          'id': '2',
          'text': 'Thanks for keeping me updated! What\'s the receipt for?',
          'isFromSitter': false,
          'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
        },
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.receipt.petOwnerName} • ${widget.receipt.petName}'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showReceiptDetails(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildReceiptPreview(),
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceiptPreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.receipt.imagePath.startsWith('assets/')
                ? Icon(Icons.receipt, color: Colors.grey.shade600)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.receipt.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.receipt, color: Colors.grey.shade600);
                      },
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receipt.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (widget.receipt.amount != null)
                  Text(
                    '\$${widget.receipt.amount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  _formatDateTime(widget.receipt.dateTime),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _sendReceipt,
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Send'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isFromSitter = message['isFromSitter'] as bool;
    
    return Align(
      alignment: isFromSitter ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isFromSitter ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isFromSitter ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(message['timestamp']),
              style: TextStyle(
                color: isFromSitter ? Colors.white70 : Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
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
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _sendReceipt() {
    ReceiptService.sendReceiptToOwner(widget.receipt.id);
    
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': 'Receipt sent: ${widget.receipt.description}',
        'isFromSitter': true,
        'timestamp': DateTime.now(),
        'isReceipt': true,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Receipt sent to ${widget.receipt.petOwnerName}'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'isFromSitter': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();

    // Simulate owner response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': 'Thanks for the update!',
            'isFromSitter': false,
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  void _showReceiptDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.receipt.description),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.receipt.amount != null)
                Text(
                  'Amount: \$${widget.receipt.amount!.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 8),
              Text('Pet Owner: ${widget.receipt.petOwnerName}'),
              Text('Pet: ${widget.receipt.petName}'),
              Text('Date: ${_formatDateTime(widget.receipt.dateTime)}'),
              Text('Status: ${widget.receipt.status.displayName}'),
              if (widget.receipt.notes != null) ...[
                const SizedBox(height: 8),
                Text('Notes: ${widget.receipt.notes}'),
              ],
            ],
          ),
          actions: [
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
