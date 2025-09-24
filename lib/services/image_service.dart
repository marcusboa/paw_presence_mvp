import 'package:flutter/material.dart';

class ImageService {
  // Enhanced image widget with loading states and error handling
  static Widget enhancedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    bool showLoadingIndicator = true,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: borderRadius,
        ),
        child: Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: frame != null
                  ? child
                  : placeholder ?? _buildImagePlaceholder(width, height, showLoadingIndicator),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _buildImageError(width, height);
          },
        ),
      ),
    );
  }

  // Pet avatar with fallback
  static Widget petAvatar({
    required String petName,
    String? imageUrl,
    double radius = 24,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.deepPurple.shade200,
      child: imageUrl != null
          ? ClipOval(
              child: Image.asset(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildAvatarFallback(petName, radius);
                },
              ),
            )
          : _buildAvatarFallback(petName, radius),
    );
  }

  // User avatar with initials fallback
  static Widget userAvatar({
    required String userName,
    String? imageUrl,
    double radius = 24,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.deepPurple.shade200,
      child: imageUrl != null
          ? ClipOval(
              child: Image.asset(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildUserAvatarFallback(userName, radius);
                },
              ),
            )
          : _buildUserAvatarFallback(userName, radius),
    );
  }

  // Gallery image with hero animation
  static Widget galleryImage({
    required String imageUrl,
    required String heroTag,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return Hero(
      tag: heroTag,
      child: GestureDetector(
        onTap: onTap,
        child: enhancedImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Image placeholder with shimmer effect
  static Widget _buildImagePlaceholder(double? width, double? height, bool showLoading) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: showLoading
          ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey.shade400,
                  ),
                ),
              ),
            )
          : Icon(
              Icons.image,
              size: 32,
              color: Colors.grey.shade400,
            ),
    );
  }

  // Image error widget
  static Widget _buildImageError(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 32,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            'Image not found',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // Avatar fallback for pets
  static Widget _buildAvatarFallback(String petName, double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: _getAvatarColor(petName),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          petName.isNotEmpty ? petName[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Avatar fallback for users
  static Widget _buildUserAvatarFallback(String userName, double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: _getAvatarColor(userName),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Generate avatar color based on name
  static Color _getAvatarColor(String name) {
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  // Image gallery viewer
  static void showImageGallery({
    required BuildContext context,
    required List<String> imageUrls,
    int initialIndex = 0,
    String? title,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageGalleryViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          title: title,
        ),
      ),
    );
  }

  // Photo capture simulation
  static Future<String?> capturePhoto(BuildContext context) async {
    // Simulate camera capture with loading
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _PhotoCaptureDialog(),
    );
  }
}

// Image gallery viewer widget
class _ImageGalleryViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? title;

  const _ImageGalleryViewer({
    required this.imageUrls,
    this.initialIndex = 0,
    this.title,
  });

  @override
  State<_ImageGalleryViewer> createState() => _ImageGalleryViewerState();
}

class _ImageGalleryViewerState extends State<_ImageGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title ?? 'Photos'),
        actions: [
          Text(
            '${_currentIndex + 1} / ${widget.imageUrls.length}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: 'gallery_${widget.imageUrls[index]}_$index',
              child: InteractiveViewer(
                child: Image.asset(
                  widget.imageUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Photo capture dialog
class _PhotoCaptureDialog extends StatefulWidget {
  const _PhotoCaptureDialog();

  @override
  State<_PhotoCaptureDialog> createState() => _PhotoCaptureDialogState();
}

class _PhotoCaptureDialogState extends State<_PhotoCaptureDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
    
    // Simulate photo capture delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop('captured_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_camera,
                    size: 64,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Capturing Photo...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
