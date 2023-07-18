
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task1/firebase_api.dart';
import 'notificate/Calender/page_calander.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   // NotificationService().initNotification();
   await firebaseApi().initnotific();
    runApp(MyApp()); 
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     localizationsDelegates: [ 
       GlobalMaterialLocalizations.delegate
],
supportedLocales: [
  const Locale('ar'),  const Locale('en'),
],
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       debugShowCheckedModeBanner: false,
    

      home:  Directionality(
        textDirection: TextDirection.rtl, // add this  textDirection: TextDirection.rtl, // set this property
  child:
   //AddNotice(),
 //MyHomePage(title: 'Flutter Local Notifications'),
  TableBasicsExample(),
 // TableMultiExample()
  ),
    );
  }
}
