import 'dart:io';

import 'package:contact_list/model/contact.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ContactRepository {
  final contactObjectName = 'contact';

  Future<bool> createOrUpdateContact (Contact contact) async{
    var contactObject = ParseObject(contactObjectName);

    contactObject.set('name', contact.name);
    contactObject.set('phone', contact.phone);
    contactObject.set('email', contact.email);
    contactObject.set('photo_path', contact.getPath());
    contactObject.objectId = contact.id;

    ParseResponse res = await contactObject.save();
    return res.success;
  }

  Future<List<Contact>> listContacts () async{
    QueryBuilder<ParseObject> queryListContacts = QueryBuilder<ParseObject>(ParseObject(contactObjectName));
    ParseResponse response = await queryListContacts.query();

    if(response.success && response.results != null){
      return (response.results as List<ParseObject>).map(
        (e) => Contact.fromParseObject(e)
      ).toList();
    }
    return[];
  }

   Future<void> deleteContact (String id) async{
    var contactObject = ParseObject(contactObjectName)..objectId = id;
    await contactObject.delete();
  }
}