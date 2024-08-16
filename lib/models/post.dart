class Post {
  final int id;
  final int userId;
  final String content;
  final String createdAtFormatted;
  final List<String> mediaUrls;
  final String username;
  final String profilePhoto;
  int likeCount;  // Make mutable
  int commentCount;  // Make mutable
  bool follow;  // Make mutable
  bool saved;  // Make mutable
  final List<dynamic> likes;
  final List<dynamic> comments;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAtFormatted,
    required this.mediaUrls,
    required this.username,
    required this.profilePhoto,
    required this.likeCount,
    required this.commentCount,
    required this.follow,
    required this.saved,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAtFormatted: json['created_at_formatted'],
      mediaUrls: List<String>.from(json['media_urls'].split(',')),
      username: json['username'],
      profilePhoto: json['profile_photo'] ?? '',
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
      follow: json['follow'] == 1,
      saved: json['saved'] == 1,
      likes: json['likes'] ?? [],
      comments: json['comments'] ?? [],
    );
  }
}