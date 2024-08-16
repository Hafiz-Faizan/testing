// controllers/dashboard_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class DashboardController {
  final int userId;

  DashboardController({required this.userId});

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://emmerge-backend.vercel.app/api/posts/feed/$userId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void likePost(Post post) async {
    final isLiked = post.likes.any((like) => like['user_id'] == userId);

    if (isLiked) {
      post.likes.removeWhere((like) => like['user_id'] == userId);
      post.likeCount--;
      _unlikePostOnServer(post.id);
    } else {
      post.likes.add({'user_id': userId});
      post.likeCount++;
      _likePostOnServer(post.id);
    }
  }

  void _likePostOnServer(int postId) async {
    await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/likes/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'post_id': postId}),
    );
  }

  void _unlikePostOnServer(int postId) async {
    await http.delete(
      Uri.parse('https://emmerge-backend.vercel.app/api/likes/unlike'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'post_id': postId}),
    );
  }

  void savePost(Post post) async {
    post.saved = !post.saved;

    if (post.saved) {
      _savePostOnServer(post.id);
    } else {
      _unsavePostOnServer(post.id);
    }
  }

  void _savePostOnServer(int postId) async {
    await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/saved/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'post_id': postId}),
    );
  }

  void _unsavePostOnServer(int postId) async {
    await http.delete(
      Uri.parse('https://emmerge-backend.vercel.app/api/saved/unsave'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'post_id': postId}),
    );
  }

  void followUser(Post post) async {
    post.follow = !post.follow;

    if (post.follow) {
      _followUserOnServer(post.userId);
    } else {
      _unfollowUserOnServer(post.userId);
    }
  }

  void _followUserOnServer(int followingId) async {
    await http.post(
      Uri.parse('https://emmerge-backend.vercel.app/api/follow/follow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'following_id': followingId}),
    );
  }

  void _unfollowUserOnServer(int followingId) async {
    await http.delete(
      Uri.parse('https://emmerge-backend.vercel.app/api/follow/unfollow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'following_id': followingId}),
    );
  }
}