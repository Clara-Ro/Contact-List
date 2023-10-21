import 'package:contact_list/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final keyApplicationId = dotenv.env['APPID'];
  final keyClientKey = dotenv.env['CLIENTID'];
  final keyParseServerUrl = dotenv.env['SERVERURL'];

  await Parse().initialize(keyApplicationId!, keyParseServerUrl!,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const ContactList());
}
