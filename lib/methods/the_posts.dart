// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class thePost extends StatelessWidget {
  final String message;
  final String user;
final String? imageUrl;

  const thePost({
    Key? key,
    required this.message,
    required this.user,
     required this.imageUrl,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // profile pic
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
          // message and user info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 10),
                Text(message),
              ],
            ),
          ),
           if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 100,
                width: 100,
      )],
      ),
    );
  }
}
