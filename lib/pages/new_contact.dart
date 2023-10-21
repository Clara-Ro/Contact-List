import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contact_list/model/contact.dart';
import 'package:contact_list/repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class NewContact extends StatefulWidget {
  final Function update;
  NewContact({super.key, required this.update});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {

  Contact contact = Contact();
  ContactRepository repository = ContactRepository();
  ImagePicker picker = ImagePicker();

  Future<void> createContact (BuildContext context) async{
    await repository.createOrUpdateContact(contact);
    Navigator.pop(context);
    widget.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff77AD78),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: const Text('Criar Novo Contato'),
        actions: [
         Padding(
           padding: const EdgeInsets.only(right:10),
           child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                  Color(0xff8FD694)
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  )
                )
              ),
              onPressed: () => createContact(context), 
              child: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.black87
                ),
              )
            ),
         )
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async{
              contact.setPhoto(await picker.pickImage(source: ImageSource.gallery));
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 150,
              height: 150,
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                backgroundImage: contact.photo != null ? FileImage(File(contact.photo!.path)) : null,
                child: contact.photo == null ? 
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ): Container()
              ),
            ),
          ),
          Padding (
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: contact.setName,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.people_alt_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Nome',
                hintText: 'Digite o nome'
              ),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
            )
          ),
          Padding (
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: contact.setPhone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Telefone',
                hintText: 'Digite o telefone'
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter()
              ],
            )
          ),
          Padding (
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: contact.setEmail,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white)
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                labelText: 'Email',
                hintText: 'Digite o email'
              ),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
            )
          ),
        ],
      ),
    );
  }
}