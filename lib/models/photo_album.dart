import '../models/pet_photo.dart';

class PhotoAlbum {
  final int id;
  final int jobId;
  final int petId;
  final String petName;
  final String sitterName;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime creationDate;
  final List<PetPhoto> photos;
  final String? coverPhotoUrl;

  const PhotoAlbum({
    required this.id,
    required this.jobId,
    required this.petId,
    required this.petName,
    required this.sitterName,
    required this.startDate,
    required this.endDate,
    required this.creationDate,
    required this.photos,
    this.coverPhotoUrl,
  });

  String get title => "$petName's Photo Album";
  
  String get dateRangeText {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }
  
  String get formattedCreationDate {
    return _formatDate(creationDate);
  }
  
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
