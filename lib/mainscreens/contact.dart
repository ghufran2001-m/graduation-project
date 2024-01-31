// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String number;

  Contact(this.id, this.name, this.number);

  // Convert Contact object to a map for Firebase Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'number': number};
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late CollectionReference contactCollection;

  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contactCollection = FirebaseFirestore.instance.collection('contacts');
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    QuerySnapshot querySnapshot = await contactCollection.get();
    contacts = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Contact(doc.id, data['name'], data['number']);
    }).toList();

    setState(() {
      filteredContacts = contacts;
    });
  }

  Future<void> _deleteContact(String contactId) async {
    await contactCollection.doc(contactId).delete();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Emergency Contacts",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredContacts = contacts
                      .where((contact) => contact.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Contact',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      filteredContacts = contacts;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(filteredContacts[index].id),
                  background: Container(
                    color: Colors.red,
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteContact(filteredContacts[index].id);
                  },
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    title: Text(filteredContacts[index].name),
                    subtitle: Text(filteredContacts[index].number),
                    onTap: () {
                      sendSOS(context, filteredContacts[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContactPage(),
            ),
          );

          if (newContact != null) {
            // Save the new contact to Firebase Firestore
            await contactCollection.add(newContact.toMap());
            _loadContacts();
          }
        },
        backgroundColor: Colors.pink[200],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void sendSOS(BuildContext context, Contact contact) {
    print('Sending SOS to ${contact.name} (${contact.number})');
    // Implement the SOS functionality using the selected contact
    // You can use the contact information to send the SOS message
  }
}

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Contact Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Number'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Create a new contact and send it back to the previous page
                Navigator.pop(
                  context,
                  Contact('', nameController.text, numberController.text),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
              child: const Text(
                "Save Contact",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
