// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String number;

  Contact(this.id, this.name, this.number);

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
            height: 25,
          ),
          Text(
            "Emergency Contacts",
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 10),
                    buildContactTile(filteredContacts[index]),
                  ],
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

  Widget buildContactTile(Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
        ),
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            'Contact: ${contact.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(contact.number),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon:  Icon(Icons.edit, color: Colors.grey[900]),
                onPressed: () {
                  _editContact(contact);
                },
              ),
              IconButton(
                icon:  Icon(Icons.delete, color: Colors.pink[900]),
                onPressed: () {
                  _deleteContact(contact.id);
                },
              ),
            ],
          ),
          onTap: () {
            sendSOS(context, contact);
          },
        ),
      ),
    );
  }

  void _editContact(Contact contact) async {
    final editedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactPage(contact: contact),
      ),
    );

    if (editedContact != null) {
      await contactCollection.doc(contact.id).update(editedContact.toMap());
      _loadContacts();
    }
  }

  void sendSOS(BuildContext context, Contact contact) {
    print('Sending SOS to ${contact.name} (${contact.number})');
  }
}

class EditContactPage extends StatefulWidget {
  final Contact contact;

  const EditContactPage({Key? key, required this.contact}) : super(key: key);

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name;
    numberController.text = widget.contact.number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        title: const Text('Edit Contact'),
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
              onPressed: () {
                Navigator.pop(
                  context,
                  Contact(widget.contact.id, nameController.text, numberController.text),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
              child: const Text(
                "Save Changes",
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

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

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
              onPressed: () {
                Navigator.pop(
                  context,
                  Contact('', nameController.text, numberController.text),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
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
