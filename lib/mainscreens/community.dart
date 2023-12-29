// ignore_for_file: avoid_print, camel_case_types
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/methods/text_field.dart';
import 'package:graduation_project/methods/the_posts.dart';
import 'package:image_picker/image_picker.dart';

class community_screen extends StatefulWidget {
  const community_screen({super.key, required String username});

  @override
  State<community_screen> createState() => _community_screenState();
}

class _community_screenState extends State<community_screen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  late String loggedInUsername = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Fetch the logged-in username when the widget initializes
    fetchLoggedInUsername();
  }

  // Function to fetch the logged-in username from Firestore
  Future<void> fetchLoggedInUsername() async {
    try {
      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.phoneNumber)
          .get();

      // Get the username from the user data
      setState(() {
        loggedInUsername =
            userSnapshot['username'] ?? ''; // Use an empty string as a fallback
      });
    } catch (e) {
      print('Error fetching logged-in user data: $e');
    }
  }

  // Function to pick an image from the gallery
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

  // Function to post a message
  void postMessage() async {
    if (textController.text.isNotEmpty || _image != null) {
      String? imageUrl = await uploadImage();
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserNumber': currentUser.phoneNumber,
        'Message': textController.text,
        'ImageURL': imageUrl,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });

      setState(() {
        textController.clear();
        _image = null;
      });
    }
  }

  // Function to upload an image to Firebase Storage
  Future<String?> uploadImage() async {
    if (_image == null) {
      return null;
    }

    try {
      String filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('asset')
          .child(filename);

      await reference.putFile(_image!);

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
         const SizedBox(
          height: 15,
        ),
        Text(
          "Logged in as: $loggedInUsername",
          style: GoogleFonts.montserrat(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
       
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

                    String? imageUrl = post.data().containsKey('ImageURL')
                        ? post['ImageURL']
                        : null;

                    return ThePost(
                      message: post['Message'],
                      user: post['UserNumber'],
                      imageUrl: imageUrl,
                      postId: post.id,
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
        Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MyTextField(
                  controller: textController,
                  hintText: "Share something with us",
                  style: TextStyle(color: Colors.grey[200]),
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
        if (_image != null)
          Image.file(
            _image!,
            height: 100,
            width: 100,
          ),
        
      ],
    );
  }
}
