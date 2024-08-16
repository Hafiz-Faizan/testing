import 'package:testing/views/Account_setting_Page.dart';
import 'package:testing/views/Chat_main_Screen.dart';
import 'package:testing/views/Share_bottomsheet.dart';
import 'package:testing/views/comment_bottomsheet.dart';
import 'package:testing/views/post_restrictionsheet.dart';
import 'package:testing/views/search%20page/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../main.dart';
import '../models/post.dart';
import '../controllers/dashboard_controller.dart';
import 'add%20post/AddPostScreen.dart';
import 'custom_bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  var userId;

  DashboardScreen({required this.userId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController _controller;
  List<Post> _posts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController(userId: widget.userId);
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    _posts = await _controller.fetchPosts();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (_selectedIndex) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(userId: widget.userId),
            ),
          );
          break;
        case 2:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ChatScreen(currentUserId: widget.userId),
          //   ),
          // );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
        ),
        title: Text(
          "Feed",
          style: TextStyle(
            fontFamily: 'Instagram Sans',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/Emergelogo.png',
            width: 40,
            height: 40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/images/ionic-ionicons-notifications-outline-1.svg',
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return _buildPost(
                  userImage: post.profilePhoto.isNotEmpty
                      ? CachedNetworkImageProvider(post.profilePhoto)
                      : AssetImage('assets/images/user.png') as ImageProvider,
                  userName: post.username,
                  postTime: post.createdAtFormatted,
                  mediaUrls: post.mediaUrls,
                  likes: '${post.likeCount} likes',
                  comments: 'View all ${post.commentCount} comments',
                  description: post.content,
                  follow: post.follow,
                  saved: post.saved,
                  currentUserId: widget.userId,
                  postLikes: post.likes,
                  postId: post.id,
                  followingId: post.userId,
                  index: index,
                );
              },
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(camera: cameras.first),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF704DE2),
          shape: CircleBorder(),
          elevation: 5.0,
        ),
      ),
    );
  }

  Widget _buildPost({
    required ImageProvider userImage,
    required String userName,
    required String postTime,
    required List<String> mediaUrls,
    required String likes,
    required String comments,
    required String description,
    required bool follow,
    required bool saved,
    required int currentUserId,
    required List<dynamic> postLikes,
    required int postId,
    required int followingId,
    required int index,
  }) {
    final bool isLiked =
        postLikes.any((like) => like['user_id'] == currentUserId);
    final Color likeIconColor = isLiked ? Color(0xFF704DE2) : Color(0xFFD9D9D9);
    final Color saveIconColor = saved ? Color(0xFF704DE2) : Color(0xFFD9D9D9);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side:
            BorderSide(color: Colors.grey[100]!, width: 0), // Added thin border
      ),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: userImage,
                    radius: 15,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.length > 12
                            ? '${userName.substring(0, 16)}...'
                            : userName,
                        style: TextStyle(
                          fontFamily: 'Instagram Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        postTime,
                        style: TextStyle(
                          fontFamily: 'Instagram Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          color: Color(0xff8f8f8f),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  follow
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          width: 110,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0x77F6F7FA),
                            borderRadius: BorderRadius.circular(
                                10), // Apply circular border radius
                            // You can also use BorderRadius.only to specify different radii for each corner
                          ),
                          child: SizedBox(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _controller.followUser(_posts[index]);
                                });
                              },
                              child: Text('Following',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          width: 110,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0x77F6F7FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _controller.followUser(_posts[index]);
                                });
                              },
                              child: Text('Follow',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) => OptionsBottomSheet(
                            postId: postId), // Passing the postId to the sheet
                      );
                    },
                    child: SvgPicture.asset('assets/images/option.svg'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'Hellix',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildMediaContent(mediaUrls),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.likePost(_posts[index]);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/heart.svg',
                      color: likeIconColor,
                      width: 25, // Adjusted size
                      height: 25, // Adjusted size
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        builder: (context) =>
                            CommentsBottomSheet(postId: postId.toString()),
                      );
                    },
                    child: SvgPicture.asset('assets/images/chat-round.svg',
                        width: 25, // Adjusted size
                        height: 25 // Adjusted size
                        ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        builder: (context) => ShareBottomSheet(),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/images/Vector.svg', // Updated with the correct share icon
                      width: 25, // Adjusted size
                      height: 25, // Adjusted size
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.savePost(_posts[index]);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/images/Saved.svg',
                      color: saveIconColor,
                      width: 25, // Adjusted size
                      height: 25, // Adjusted size
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                likes,
                style: TextStyle(
                  fontFamily: 'Instagram Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                comments,
                style: TextStyle(
                  fontFamily: 'Instagram Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: Color(0xff8f8f8f),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(List<String> mediaUrls) {
    const double imageHeight = 370;

    if (mediaUrls.length > 1) {
      return SizedBox(
        height: imageHeight,
        child: ImageSlideshow(
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 3000,
          isLoop: true,
          children: mediaUrls
              .map((url) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: CachedNetworkImageProvider(url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: imageHeight,
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image(
          image: CachedNetworkImageProvider(mediaUrls.first),
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
