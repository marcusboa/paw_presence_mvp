class Job {
  final int id;
  final int petOwnerId;
  final int petSitterId;
  final String petSitterName;
  final String sitterName; // Added this alias for consistency
  final List<int> petIds;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final List<int>? albumIds; // IDs of photo albums created for this job

  const Job({
    required this.id,
    required this.petOwnerId,
    required this.petSitterId,
    required this.petSitterName,
    required this.petIds,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.albumIds,
  }) : sitterName = petSitterName; // Initialize the alias
}
