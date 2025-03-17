import '../models/pest.dart';

class Report {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String pestName;
  final String? pestScientificName;
  final String imageUrl;
  final DateTime timestamp;
  final String? location;
  final String? description;
  final RiskLevel riskLevel;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isVerified;
  
  Report({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.pestName,
    this.pestScientificName,
    required this.imageUrl,
    required this.timestamp,
    this.location,
    this.description,
    required this.riskLevel,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.isVerified,
  });
  
  Report copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? pestName,
    String? pestScientificName,
    String? imageUrl,
    DateTime? timestamp,
    String? location,
    String? description,
    RiskLevel? riskLevel,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isVerified,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      pestName: pestName ?? this.pestName,
      pestScientificName: pestScientificName ?? this.pestScientificName,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      description: description ?? this.description,
      riskLevel: riskLevel ?? this.riskLevel,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

