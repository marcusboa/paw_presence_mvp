import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pet_photo.dart';
import '../models/photo_album.dart';
import '../services/photo_album_service.dart';

class PhotoSlideshow extends StatefulWidget {
  final PhotoAlbum album;
  final int autoPlayDurationSeconds;

  const PhotoSlideshow({
    super.key,
    required this.album,
    this.autoPlayDurationSeconds = 4,
  });

  @override
  State<PhotoSlideshow> createState() => _PhotoSlideshowState();
}

class _PhotoSlideshowState extends State<PhotoSlideshow> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(
      Duration(seconds: widget.autoPlayDurationSeconds), 
      (timer) {
        if (_isPlaying) {
          // Get the total number of pages (title page + photos)
          final totalPages = widget.album.photos.isEmpty ? 1 : widget.album.photos.length + 1;
          
          if (_currentPage < totalPages - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.album.photos.isEmpty) {
      return _buildTitlePage(context); // Always show title page even if no photos
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.album.photos.isEmpty ? 1 : widget.album.photos.length + 1,
            itemBuilder: (context, index) {
              // First page is always the title page
              if (index == 0) {
                return _buildTitlePage(context);
              } else {
                // Adjust index to account for title page
                final photo = widget.album.photos[index - 1];
                return _buildPhotoSlide(photo, context);
              }
            },
          ),
        ),
        _buildSlideshowControls(context),
      ],
    );
  }

  Widget _buildPhotoSlide(PetPhoto photo, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            Image.asset(
              photo.imageUrl,
              fit: BoxFit.cover,
            ),
            
            // Bottom gradient overlay for text readability
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and time
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          PhotoAlbumService.formatDate(photo.captureDate),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          PhotoAlbumService.formatTime(photo.captureDate),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Caption
                    Text(
                      photo.caption,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // Source tag
                    if (photo.isFromChat)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Shared in Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the title page
  Widget _buildTitlePage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade700,
            Colors.deepPurple.shade300,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image with overlay
            if (widget.album.coverPhotoUrl != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    widget.album.coverPhotoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Album content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Album icon
                    const Icon(
                      Icons.photo_album,
                      color: Colors.white,
                      size: 72,
                    ),
                    const SizedBox(height: 24),
                    
                    // Album title
                    Text(
                      widget.album.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Date range
                    Text(
                      "from ${widget.album.dateRangeText}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Photo count
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${widget.album.photos.length} photos",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideshowControls(BuildContext context) {
    // Calculate total pages (title page + photos)
    final totalPages = widget.album.photos.isEmpty ? 1 : widget.album.photos.length + 1;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey.shade200,
      child: Column(
        children: [
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < totalPages; i++)
                Container(
                  width: i == _currentPage ? 16 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i == _currentPage ? Colors.deepPurple : Colors.grey.shade400,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              IconButton(
                onPressed: () {
                  if (_currentPage > 0) {
                    if (_currentPage == 1) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.skip_previous),
                color: Colors.deepPurple,
                iconSize: 32,
              ),
              
              // Play/Pause button
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                color: Colors.deepPurple,
                iconSize: 48,
              ),
              
              // Next button
              IconButton(
                onPressed: () {
                  if (_currentPage < (widget.album.photos.isEmpty ? 0 : widget.album.photos.length)) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(Icons.skip_next),
                color: Colors.deepPurple,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
