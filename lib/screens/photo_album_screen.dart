import 'package:flutter/material.dart';
import '../models/photo_album.dart';
import '../services/photo_album_service.dart';
import '../widgets/photo_slideshow.dart';
import '../widgets/custom_app_bar.dart';

class PhotoAlbumScreen extends StatefulWidget {
  final int albumId; // Display a specific album

  const PhotoAlbumScreen({
    super.key,
    required this.albumId,
  });

  @override
  State<PhotoAlbumScreen> createState() => _PhotoAlbumScreenState();
}

class _PhotoAlbumScreenState extends State<PhotoAlbumScreen> {
  late PhotoAlbum _album;
  bool _albumLoaded = false;
  
  @override
  void initState() {
    super.initState();
    
    // Get the album
    _loadAlbum();
  }
  
  void _loadAlbum() {
    final album = PhotoAlbumService.getAlbumById(widget.albumId);
    if (album != null) {
      setState(() {
        _album = album;
        _albumLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_albumLoaded) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Photo Album',
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: CustomAppBar(
        title: '${_album.petName}\'s Album',
        actions: [
          // Share button
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature is for display only')),
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          // Album info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.photo_album, size: 24, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_album.photos.length} photos',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _album.dateRangeText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Download button
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download feature is for display only')),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Photo slideshow
          Expanded(
            child: PhotoSlideshow(
              album: _album,
              autoPlayDurationSeconds: 4,
            ),
          ),
        ],
      ),
      // FAB to add more photos
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPhotoOptions(context);
        },
        tooltip: 'Add photos',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }



  void _showAddPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Add Photos to Album',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepPurple),
                title: const Text('Take a New Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera feature is for display only')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.deepPurple),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery feature is for display only')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.deepPurple),
                title: const Text('Import from Chat'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Import from chat feature is for display only')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
