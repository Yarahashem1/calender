// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../addNotice.dart';




class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}
List<dynamic> itemss = [];
List<dynamic> dates = [];
List<DateTime> newdates=[];

 void feach() async {
    await FirebaseFirestore.instance.collection('notific').get().then((value) {
        for (int i = 0; i < value.size; i++) {
          dates.add(value.docs.elementAt(i)['date']);
        }
   });

 }


void nee() {
    feach();
    for(int i=0;i<dates.length;i++){
             print("lllllllllllllllllllll"+dates[i].split("-").toString());
           List<String> newlist = dates[i].split("-");
           newdates.add(DateTime.utc(int.parse(newlist[2]),int.parse(newlist[1]),int.parse(newlist[0])));
           newlist = [];
    }
   //print(""+newdates.toString());
 }
 
class _TableBasicsExampleState extends State<TableBasicsExample> {
 


  @override
  Widget build(BuildContext context) {
     nee();
    return Scaffold(
     
      appBar: AppBar(
      //  title: Text('TableCalendar - Basics'),
      ),
      body: Column(
        children: [
          SfDateRangePicker(    view: DateRangePickerView.month,
    initialSelectedDates: newdates
    ,    selectionMode: DateRangePickerSelectionMode.multiple,
  ),

            const SizedBox(height: 8.0),
          Expanded(
            child:
                       StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('notific')
                            // .doc(FirebaseAuth.instance.currentUser!.email)
                            // .collection('items')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) 
                            {
                          if (snapshot.hasData ) {
                            itemss = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: itemss.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Build each item here
                                // print( _selectedDay.toString().split(" ")[0]+"klkkkkkkkk"+itemss[index]['date']);
                                //if( _selectedDay.toString().split(" ")[0]==itemss[index]['date'])
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                               
                                  margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                                
                                   
                                   child:   Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4, top: 10),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                               
                                                itemss[index]['obj'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 0),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    itemss[index]['date'],
                                                    style: TextStyle(
                                                        color: Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                  ),
                                           ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                 
                                );
                                // else 
                                // return Container(    
                                //     );
                               
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
             floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromARGB(255, 65, 55, 55),
        onPressed: () {
          // إضافة الوظائف التي ترغب في تنفيذها عند النقر على الزر
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