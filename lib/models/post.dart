class Post {
  final String id;
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final List<Comment> comments;
  int likes;
  bool isLiked;
  
  Post({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.comments,
    required this.likes,
    this.isLiked = false,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = [];
    
    if (json['comments'] != null) {
      comments = (json['comments'] as List)
          .map((item) => Comment.fromJson(item))
          .toList();
    }
    
    return Post(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      timeAgo: json['timeAgo'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      comments: comments,
      likes: json['likes'],
      isLiked: json['isLiked'] ?? false,
    );
  }
}

class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String text;
  final String timeAgo;
  
  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timeAgo,
  });
  
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      text: json['text'],
      timeAgo: json['timeAgo'],
    );
  }
}

