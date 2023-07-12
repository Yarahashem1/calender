import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/app_screens/widget/Food.dart';


//import '../components_login/components.dart';

class noticeDisply extends StatefulWidget {
  const noticeDisply({Key? key}) : super(key: key);

  @override
  State<noticeDisply> createState() => _noticeDisplyState();
}

List<dynamic> itemss = [];

class _noticeDisplyState extends State<noticeDisply> {
  String listingRoute = '/listing_screen';
  @override
  Widget build(BuildContext context) {
   // final PageController controller = PageController();
   // Color? color = Color(0XFF9A9A9D);
    return DefaultTabController(
      length: 1,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFEDEDED),
               body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TabBarView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('notific')
                            // .doc(FirebaseAuth.instance.currentUser!.email)
                            // .collection('items')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) 
                            {
                          if (snapshot.hasData) {
                            itemss = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: itemss.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Build each item here
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                 
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                   
                                      Column(
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
                                                        FontWeight.w500),
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
                                                        color: Colors.green,
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
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),

                      // Item_widget(),
                      // Item_widget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}