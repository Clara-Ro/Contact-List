// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Contact {
  String? name;
  String? phone;
  String? email;
  XFile? photo;
  String? photoUrl;
  String? id;

  void setName (String? value) => name = value;
  void setPhone (String? value) => phone = value;
  void setEmail (String? value) => email = value;
  void setPhoto (XFile? value) => photo = value;
  void setPhotoUrl (String? value) => photoUrl = value;

  Contact({
    this.name,
    this.phone,
    this.email,
    this.photo,
    this.photoUrl,
    this.id,
});

  String getPath (){
    if (photo != null) {
      return photo!.path;
    } else if (photoUrl != null){
      return photoUrl!;
    }
    return '';
  }

  factory Contact.fromParseObject (ParseObject object){
    Contact contact = Contact();
    contact.name = object.get('name');
    contact.phone = object.get('phone');
    contact.email = object.get('email');
    contact.photoUrl =object.get('photo_path');
    contact.id = object.get('objectId');

    return contact;
  }


  Contact copyWith({
    String? name,
    String? phone,
    String? email,
    XFile? photo,
    String? photoUrl,
    String? id,
  }) {
    return Contact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      photoUrl: photoUrl ?? this.photoUrl,
      id: id ?? this.id,
    );
  }
}
