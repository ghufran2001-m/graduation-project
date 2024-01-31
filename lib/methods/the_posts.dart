// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/methods/like_button.dart';

class ThePost extends StatefulWidget {
  final String message;
  final String user;
  final String? imageUrl;
  final String postId;
  final List<String> likes;

  const ThePost({
    Key? key,
    required this.message,
    required this.user,
    required this.imageUrl,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<ThePost> createState() => _ThePostState();
}

class _ThePostState extends State<ThePost> {
  bool isLiked = false;
  late String username = "";
  late bool isCurrentUserPost;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.phoneNumber);
    isCurrentUserPost = currentUser.phoneNumber == widget.user;
    fetchUsername();
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> fetchUsername() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.user)
          .get();

      setState(() {
        username = userSnapshot["username"];
      });
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.phoneNumber])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.phoneNumber])
      });
    }
  }

  void deletePost() async {
    await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[600],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.message,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (widget.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(left:20, top:10),
              child: Image.network(
                widget.imageUrl!,
                height: 200,
                width: 200,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (isCurrentUserPost)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deletePost,
                ),
            ],
          )
        ],
      ),
    );
  }
}
