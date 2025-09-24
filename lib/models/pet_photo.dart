class PetPhoto {
  final int id;
  final String imageUrl;
  final DateTime captureDate;
  final String caption;
  final int petId;
  final int jobId;
  final String source; // Who took the photo (e.g. 'Pet Owner', 'Pet Sitter')
  final bool isFromChat;

  const PetPhoto({
    required this.id,
    required this.imageUrl,
    required this.captureDate,
    required this.caption,
    required this.petId,
    required this.jobId,
    required this.source,
    this.isFromChat = false,
  });
}
