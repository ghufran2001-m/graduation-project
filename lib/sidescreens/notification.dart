// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = fetchNotifications();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return buildNotificationTile(notifications[index], index);
        },
      ),
    );
  }

  Widget buildNotificationTile(NotificationModel notification, int index) {
    Widget notificationIcon;
    Color tileColor;
    String notificationText;

    if (notification.type == 'like') {
      notificationIcon = const Icon(Icons.thumb_up, color: Colors.white);
      tileColor = Colors.pink[100]!;
      notificationText = 'user Liked your post ${notification.message}';
    } else if (notification.type == 'post') {
      notificationIcon = const Icon(Icons.post_add, color: Colors.white);
      tileColor = Colors.purple[100]!;
      notificationText = 'Posted: ${notification.message}';
    } else {
      notificationIcon =
          const Icon(Icons.notification_important, color: Colors.grey);
      tileColor = Colors.grey[200]!;
      notificationText = 'Unknown notification type: ${notification.message}';
    }

    return Dismissible(
      key: Key(index.toString()),
      background: Container(
        color: Colors.pink[900],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          // Remove the dismissed item from the list
          notifications.removeAt(index);
        });
      },
      child: Container(
        color: tileColor,
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            notificationText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: notificationIcon,
        ),
      ),
    );
  }

  static List<NotificationModel> fetchNotifications() {
    return [
      NotificationModel(message: '', type: 'like'),
      NotificationModel(message: 'New post from Ran', type: 'post'),
      NotificationModel(message: '', type: 'like'),
      NotificationModel(message: 'New post from rafal', type: 'post'),
      NotificationModel(message: '', type: 'like'),
      NotificationModel(message: 'New post from user', type: 'post'),
    ];
  }
}

class NotificationModel {
  final String message;
  final String type; // e.g., like, post

  NotificationModel({
    required this.message,
    required this.type,
  });
}
