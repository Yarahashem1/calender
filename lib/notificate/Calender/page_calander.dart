import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import '../addNotice.dart';

class TableBasicsExample extends StatefulWidget {
  @override
  
  TableBasicsExampleState createState() => TableBasicsExampleState();
}

class TableBasicsExampleState extends State<TableBasicsExample> {
  List<dynamic> itemss = [];
  List<dynamic> dates = [];
  List<DateTime> newdates = [];
  bool? isbool;
  var serverToken="AAAAqX5GTL4:APA91bFGba7ZjwueoA7isgkHawr0U8z7wE9sbf7Pn7wB6P97ZT6aVbURA7kdEJxzDoN0q4T8P9CX1MEMYPJlcBcdLGoTciCJ0pTNHLG5ab_xyyc9NzJx8LH7cHtVUhWfRE6PolJW3utu";
    
Future<List<String>> find(String? s) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('notific').get();
  List<String> matchingItems = []; // قائمة لتخزين العناصر المطابقة
     isbool=false;
  for (int i = 0; i < snapshot.size; i++) {
    if (s == snapshot.docs.elementAt(i)['time']) {
      String item1 = snapshot.docs.elementAt(i)['obj'] ?? ''; // استبدل 'item1' بالحقل الفعلي الذي ترغب في استرداده
      String item2 = snapshot.docs.elementAt(i)['description'] ?? ''; // استبدل 'item2' بالحقل الفعلي الذي ترغب في استرداده
      matchingItems.add(item1);
      matchingItems.add(item2); 
      isbool = true; // تعيين قيمة isbool إلى true
      break;
    }
  }

  return matchingItems; // إرجاع القائمة
}

 sendNotify(String title, String body) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title
        },
        'priority': 'high',
        'to': await FirebaseMessaging.instance.getToken(),
      },
    ),
  );
}
    
  Future<List<dynamic>> feach() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('notific').get();

    for (int i = 0; i < snapshot.size; i++) {
      dates.add(snapshot.docs.elementAt(i)['date']);
    }
    return dates;
  }

Future<List<DateTime>> nee() async {
    
    List<dynamic> da = await feach();

    for (int i = 0; i < da.length; i++) {
      List<dynamic> newlist = da[i].split("-");
      newdates.add(DateTime.utc(int.parse(newlist[0]), int.parse(newlist[1]),int.parse(newlist[2])));
    }
    return newdates;
  }

  getToken() async{
    var token =await FirebaseMessaging.instance.getToken();
      var querySnapshot = await FirebaseFirestore.instance.collection('notific').get();
  
  for (var documentSnapshot in querySnapshot.docs) {
    var name = documentSnapshot.data()['uid'];
    print('قيمة الحقل "name": $name');
       FirebaseFirestore.instance.collection('notific').doc(name)
    .update({'token': token})
    .then((value) => print('تمت إضافة الحقل بنجاح'))
    .catchError((error) => print('فشل في إضافة الحقل: $error'));
  }
  } 
 getMessage(){
     
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('تم استلام الإشعار المباشر');
});

  }
  intialMessage() async{
    var message=await FirebaseMessaging.instance.getInitialMessage();
    if(message !=null)
      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TableBasicsExample()),
          );
  }

@override
void initState() {
  super.initState();
  //intialMessage();
  getToken();
  getMessage();
  dates = dates;
  newdates = newdates;

  // Schedule automatic notification sending
  Timer.periodic(Duration(minutes: 1), (Timer timer) async {
    var now = DateTime.now();
    List<String> matchingItems = await find('${now.hour}:${now.minute}');

    if (isbool!) {
      sendNotify(matchingItems[0], matchingItems[1]);
      //isNotificationSent = true; // تعيين المتغير إلى true بعد إرسال الإشعار
      //timer.cancel();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        actions: [Icon(Icons.menu)],
      ),
      body:
      RefreshIndicator(
        onRefresh:nee ,
        child: Column(
          children: [
     
            FutureBuilder<List<DateTime>>(
              future: nee(),
              builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SfDateRangePicker(
  view: DateRangePickerView.month,
  initialSelectedDates: snapshot.data,
  selectionMode: DateRangePickerSelectionMode.multiple,
  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      DateTime selectedDate = args.value as DateTime;
      // قم بمعالجة العنصر المحدد هنا
      print('تم اختيار التاريخ: $selectedDate');
    }
  },
);
 
                }
              },
            ),
            
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notific').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  
                  if (snapshot.hasData) {
                    itemss = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemss.length,
                      itemBuilder: (BuildContext context, int index) {   
                                
                        return
                         Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                             
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          
                              Padding(
                                padding: EdgeInsets.only(bottom: 4, top: 10),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      //textAlign:TextAlign.right,
                                    itemss[index]['obj'],
                                    style: TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                      //  textAlign:TextAlign.right,
                                        itemss[index]['date'],
                                        style: TextStyle(
                                            color: Colors.deepPurple, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 150,
                                      ),
                                         IconButton(
                        //Delete the item
                        icon: Icon(Icons.delete,color: Colors.deepPurple,),
                        onPressed: () async {
                          bool confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm delete'),
                              content: Text(
                                  'Are you sure you want to delete this item?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  onPressed: () {
                                   
                                      Navigator.of(context).pop(true);
                                  }
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            
                            await  FirebaseFirestore.instance.collection('notific').doc(itemss[index]['uid']).delete();
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TableBasicsExample()),
                          );
                          }
                        },
                      )
                 
                                    ],
                                  ),
                                ),
                              ),
                                       Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        //textAlign:TextAlign.right,
                                        itemss[index]['description'],
                                        style: TextStyle(
                                            color: Colors.deepPurple, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                         
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromARGB(255, 65, 55, 55),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotice()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
