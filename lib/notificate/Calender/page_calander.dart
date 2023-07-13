import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../addNotice.dart';

class TableBasicsExample extends StatefulWidget {
  @override
  
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  List<dynamic> itemss = [];
  List<dynamic> dates = [];
  List<DateTime> newdates = [];
  Future<List<dynamic>> feach() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('notific').get();

    for (int i = 0; i < snapshot.size; i++) {
      dates.add(snapshot.docs.elementAt(i)['date']);
    }

    print("Dates: $dates");
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
     @override
  void initState() {
    super.initState();
    dates=dates;
    newdates=newdates;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.menu)],
      ),
      body: RefreshIndicator(
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
                        return Container(
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
