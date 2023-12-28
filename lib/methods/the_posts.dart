// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/methods/like_button.dart';

class thePost extends StatefulWidget {
  final String message;
  final String user;
  final String? imageUrl;
  final String PostId;
  final List<String> likes;
  const thePost({
    Key? key,
    required this.message,
    required this.user,
    required this.imageUrl,
    required this.PostId,
    required this.likes,
  }) : super(key: key);

  @override
  State<thePost> createState() => _thePostState();
}

class _thePostState extends State<thePost> {
  // user from firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.phoneNumber);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    // Access the doc in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.PostId);
    if (isLiked) {
      // if the post is now is liked, add the user's info to the 'likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.phoneNumber])
      });
    } else {
      // if the post is nor unliked, remove the user's info from the 'likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.phoneNumber])
      });
    }
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
          // profile pic
          // the post info
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
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
                      widget.user,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.message),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),

          if (widget.imageUrl != null)
            Image.network(
              widget.imageUrl!,
              height: 200,
              width: 200,
            ),

          const SizedBox(
            height: 10,
          ),

          //the like button and others
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  // like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),

                  const SizedBox(
                    height: 5,
                  ),

                  // like count
                  Text(widget.likes.length.toString(),
                  style:TextStyle(color: Colors.grey) ,)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
