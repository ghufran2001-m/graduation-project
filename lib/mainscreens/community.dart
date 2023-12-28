// ignore_for_file: camel_case_types, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:graduation_project/methods/text_field.dart';
import 'package:graduation_project/methods/the_posts.dart';
import 'package:image_picker/image_picker.dart';

class community_screen extends StatefulWidget {
  const community_screen({super.key});

  @override
  State<community_screen> createState() => _community_screenState();
}

class _community_screenState extends State<community_screen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  void postMessage() async {
    if (textController.text.isNotEmpty || _image != null) {
      String? imageUrl = await uploadImage();
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserNumber': currentUser.phoneNumber,
        'Message': textController.text,
        'ImageURL': imageUrl, // Use the resolved URL directly
        'TimeStamp': Timestamp.now(),
        'Likes' : [],

      });

      setState(() {
        textController.clear();
        _image = null;
      });
    }
  }

  Future<String?> uploadImage() async {
    if (_image == null) {
      return null; // No image to upload
    }

    try {
      // Generate a unique filename for the image
      String filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Reference to the Firebase Storage bucket
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('asset')
          .child(filename);

      // Upload the file to Firebase Storage
      await reference.putFile(_image!);

      // Get the download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy("TimeStamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];

                    // Check if the "ImageURL" field exists
                    String? imageUrl = post.data().containsKey('ImageURL')
                        ? post['ImageURL']
                        : null;

                    return thePost(
                      message: post['Message'],
                      user: post['UserNumber'],
                      imageUrl: imageUrl,
                      PostId: post.id,
                      likes: List<String>.from(post['Likes'] ?? []),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        // Post message input
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MyTextField(
                  controller: textController,
                  hintText: "Share something with us",
                  obscureText: false,
                ),
              ),
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: postMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
        // Display selected image
        if (_image != null)
          Image.file(
            _image!,
            height: 100,
            width: 100,
          ),
        // Logged in as
        Text(
          "Logged in as: ${currentUser.phoneNumber!}",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
