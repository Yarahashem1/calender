
import 'package:firebase_messaging/firebase_messaging.dart';

class firebaseApi{
  final _firebaseMessaging=FirebaseMessaging.instance;

  Future<void> initnotific() async{
        await _firebaseMessaging.requestPermission();
        final fcmnotific=await _firebaseMessaging.getToken();

  }
}