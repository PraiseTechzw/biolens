class Comment {
  final String id;
  final String reportId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String text;
  final DateTime timestamp;
  final int likeCount;
  final bool isLiked;
  final bool isExpert;
  
  Comment({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.text,
    required this.timestamp,
    required this.likeCount,
    required this.isLiked,
    required this.isExpert,
  });
}

