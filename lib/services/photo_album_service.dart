import '../models/pet_photo.dart';
import '../models/photo_album.dart';
import 'job_service.dart';

class PhotoAlbumService {
  // Sample photo albums
  static final List<PhotoAlbum> _albums = [];
  
  // Sample images - using available images in the project
  static const List<String> _sampleImages = [
    'assets/images/golden_retriever.jpg',
    'assets/images/beagle.jpg',
    'assets/images/persian_cat.jpg',
    'assets/images/siamese_cat.jpg',
    'assets/images/golden_retriever.jpg', // Repeated to have more variety
    'assets/images/persian_cat.jpg',      // Repeated to have more variety
  ];
  
  // Sample captions
  static const List<String> _sampleCaptions = [
    'Playing in the park',
    'Enjoying some treats',
    'Naptime!',
    'Morning walk',
    'Playtime with toys',
    'Looking so cute today',
    'Bath time fun',
    'Waiting by the door',
  ];

  static void _initializeAlbums() {
    // Only initialize if not already done
    if (_albums.isNotEmpty) return;
    
    // Get all pets
    final pets = JobService.getAllPets();
    
    // For each pet, create albums for completed jobs
    for (final pet in pets) {
      final petId = pet['id'] as int;
      
      // Get all completed jobs for this pet
      final jobs = JobService.getCompletedJobsForPet(petId);
      
      // Create an album for each job
      for (final job in jobs) {
        final List<PetPhoto> photos = [];
        
        // Generate random sample photos
        final photosCount = 3 + (job.id * 2) % 5; // Between 3 and 7 photos
        
        final now = DateTime.now();
        final albumStartDate = job.startDate;
        final albumEndDate = job.endDate;
        
        for (int i = 0; i < photosCount; i++) {
          // Generate a random date within the job period
          final photoDay = albumStartDate.add(Duration(
            hours: (albumEndDate.difference(albumStartDate).inHours * i) ~/ photosCount
          ));
          
          photos.add(PetPhoto(
            id: i + 1,
            imageUrl: _sampleImages[(job.id + i) % _sampleImages.length],
            captureDate: photoDay,
            caption: _sampleCaptions[(job.id + i) % _sampleCaptions.length],
            petId: petId,
            jobId: job.id,
            source: 'Pet Sitter',
          ));
        }
        
        // Sort photos by date
        photos.sort((a, b) => a.captureDate.compareTo(b.captureDate));
        
        // Create the album
        _albums.add(PhotoAlbum(
          id: _albums.length + 1, // Unique album ID
          petId: petId,
          petName: pet['name'] as String,
          jobId: job.id,
          sitterName: job.sitterName,
          creationDate: now.subtract(Duration(days: job.id)), // Make creation dates different
          startDate: job.startDate,
          endDate: job.endDate,
          photos: photos,
          coverPhotoUrl: photos.isNotEmpty ? photos.first.imageUrl : null,
        ));
      }
    }
    
    // Sort albums by creation date (newest first)
    _albums.sort((a, b) => b.creationDate.compareTo(a.creationDate));
  }
  
  // Get all photo albums for a specific pet
  static List<PhotoAlbum> getAlbumsByPet(int petId) {
    _initializeAlbums();
    return _albums.where((album) => album.petId == petId).toList();
  }
  
  // Get album by ID
  static PhotoAlbum? getAlbumById(int albumId) {
    _initializeAlbums();
    try {
      return _albums.firstWhere((album) => album.id == albumId);
    } catch (e) {
      return null;
    }
  }
  
  // Get albums by job ID
  static List<PhotoAlbum> getAlbumsByJob(int jobId) {
    _initializeAlbums();
    return _albums.where((album) => album.jobId == jobId).toList();
  }
  
  // Check if a job has completed and an album can be created
  static bool canCreateAlbum(int jobId) {
    final job = JobService.getJobById(jobId);
    return job != null && job.isCompleted;
  }
  
  // Format date for display
  static String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  // Format time for display
  static String formatTime(DateTime time) {
    String hour = time.hour > 12 ? '${time.hour - 12}' : time.hour == 0 ? '12' : '${time.hour}';
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
