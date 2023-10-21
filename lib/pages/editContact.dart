import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contact_list/model/contact.dart';
import 'package:contact_list/repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditContact extends StatefulWidget {
  final Contact contact; 
  final Function update;
  EditContact({super.key, required this.contact, required this.update});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  bool isEditing = false;
  ImagePicker picker = ImagePicker();
  ContactRepository repository = ContactRepository();
  late Contact contact;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    contact = widget.contact.copyWith();
    controllerName.text = contact.name ?? '';
    controllerPhone.text = contact.phone ?? '';
    controllerEmail.text = contact.email ?? '';
  }

  Future<void> updateContact (BuildContext context) async{
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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: const Text('Detalhes Contato'),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                isEditing = !isEditing;
              });
            }, 
            icon: Icon(
              Icons.edit,
              color: isEditing? Colors.white : Colors.black54,
            )
          ),
          IconButton(
            onPressed: ()async{
              await repository.deleteContact(contact.id ?? '');  
              Navigator.pop(context);   
              widget.update();
            }, 
            icon: const Icon(Icons.delete)
          )
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: ()async{
              if (!isEditing) return;
              contact.setPhoto(await picker.pickImage(source: ImageSource.gallery));
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 150,
              height: 150,
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                backgroundImage: FileImage(File(contact.getPath())),
                child: contact.photoUrl == null || isEditing ? 
                  Icon(
                    Icons.add,
                    color: isEditing ? Colors.black54 : Colors.white,
                    size: 50,
                  ) : Container()
              ),
            ),
          ),
          Padding (
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: !isEditing,
              controller: controllerName,
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
              readOnly: !isEditing,
              controller: controllerPhone,
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
              readOnly: !isEditing,
              controller: controllerEmail,
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
          if(isEditing)...[
             ElevatedButton.icon(
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
              onPressed:() => updateContact(context), 
              icon: const Icon(Icons.save, color: Colors.black87,),
              label: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.black87
                ),
              )
            ),
          ]
        ],
      ),
    );
  }
}