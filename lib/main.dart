// // Copyright 2019 Aleksander Woźniak
// // SPDX-License-Identifier: Apache-2.0

// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';

// import 'notificate/Calender/complex.dart';
// import 'notificate/Calender/event.dart';
// import 'notificate/Calender/multi.dart';
// import 'notificate/Calender/page_calander.dart';
// import 'notificate/Calender/rangesel.dart';
// import 'notificate/noticeDisplay.dart';



// void main() {
//   initializeDateFormatting().then((_) => runApp(MyApp()));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TableCalendar Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StartPage(),
//     );
//   }
// }

// class StartPage extends StatefulWidget {
//   @override
//   _StartPageState createState() => _StartPageState();
// }

// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TableCalendar Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: Text('Basics'),
//               onPressed: ()
//               => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => noticeDisply()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Range Selection'),
//               onPressed: () 
//               => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableRangeExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Events'),
//               onPressed: ()
//                => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableEventsExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Multiple Selection'),
//               onPressed: () 
//               => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableMultiExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Complex'),
//               onPressed: ()
//                => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableComplexExample()),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//           ],
//         ),
//       ),
//     );
//   }
// }















import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task1/notificate/addNotice.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'notificate/Calender/multi.dart';
import 'notificate/Calender/page_calander.dart';
import 'notificate/noticeDisplay.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  TableBasicsExample(),
 // TableMultiExample()
  ),
    );
  }
}
