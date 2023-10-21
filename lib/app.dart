import 'dart:io';

import 'package:contact_list/model/contact.dart';
import 'package:contact_list/pages/editContact.dart';
import 'package:contact_list/pages/new_contact.dart';
import 'package:contact_list/repository/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff7DBA84),
        useMaterial3: true,
      ),
      home: const ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {

  ContactRepository repository = ContactRepository();
  late Future<List<Contact>> future;

  void update (){
    setState(() {
      future = repository.listContacts();   
    });
  }

  @override
  void initState() {
    super.initState();
    future = repository.listContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de contatos'),
        backgroundColor: const Color(0xff77AD78),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_,index){
                    Contact contact = snapshot.data![index];
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => EditContact(contact: contact,update: update,))
                          );
                        },
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          tileColor: const Color(0xff77AD78),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          isThreeLine: true,
                          leading: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            //abrir a foto qnd clicar
                            onTap: () {
                              showDialog(
                                context: context, 
                                builder: (_){
                                  return AlertDialog(
                                    content: Hero(
                                      tag: index,
                                      child: Image(
                                        image: FileImage(File(contact.photoUrl!))
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                            child: Hero(
                              tag: index,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(File(contact.photoUrl!)),
                              ),
                            ),
                          ),
                          title: Text(contact.name ?? ''),
                          subtitle: Text(
                            '${(contact.phone ?? '000000')} \n ${(contact.email ?? '')}',
                          ),
                        ),
                      ),
                    );
                  },
                  itemExtent: 100,
                  padding: const EdgeInsets.all(10),
                ),
              );
            }
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NewContact(update: update,))
                );
              },
              backgroundColor: const Color(0xff77AD78),
              child: const Icon(Icons.add),
            ),
          )
        ],
      )
    );
  }
}
