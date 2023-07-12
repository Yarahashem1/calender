
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task1/notificate/Calender/table.dart';

import '../addNotice.dart';


class TableMultiExample extends StatefulWidget {
  @override
  _TableMultiExampleState createState() => _TableMultiExampleState();
}
List<dynamic> itemss = [];
class _TableMultiExampleState extends State<TableMultiExample> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a LinkedHashSet is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<dynamic> dates = [];
  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async{

// try {
      
FirebaseFirestore.instance.collection('notific').get().then((value) {
      for (int i = 0; i < value.size; i++) {
        dates.add(value.docs.elementAt(i)['date']);


        setState(() {
       print("kkkkkkkkkkkkkkkkk"+dates.toString());
      _focusedDay = focusedDay;
     // Update values in a Set
      for (var dateTimee in dates) {
      print("MMMMMMMMMMMMMMMMMMM"+ dateTimee.toString());
      if (!(dateTimee.toString()== selectedDay.toString().split(" ")[0])) {
        _selectedDays.add(selectedDay);
      } else {
        _selectedDays.remove(selectedDay);
      }
      }
      print("llllllllllllllll"+_selectedDays.toString());
    });
 }});
    // } catch (error) {
    //   print('Failed to fetch data: $error');
    // }
     

  
    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              // Use values from Set to mark multiple days as selected
              return _selectedDays.contains(day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          ElevatedButton(
            child: Text('Clear selection'),
            onPressed: () {
              setState(() {
                _selectedDays.clear();
                _selectedEvents.value = [];
              });
            },
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
                               //  print( _selectedDay.toString().split(" ")[0]+"klkkkkkkkk"+itemss[index]['date']);
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