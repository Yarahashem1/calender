import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task1/notificate/Calender/page_calander.dart';


import '../component.dart';
import 'cubit_addNotice/cubit.dart';
import 'cubit_addNotice/state.dart';



// ignore: must_be_immutable
class AddNotice extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var objController = TextEditingController();
  var descriptionController = TextEditingController();
   var timeController = TextEditingController();
   var dateController = TextEditingController();
  
  TimeOfDay selectedtime=TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddNoticeCubit(),
      child: BlocConsumer<AddNoticeCubit, AddNoticetates>(
        listener: (context, state) {
          if (state is CreateNoticeErrorState) {
            showToast(
              text: 'Error in adding Notice',
              state: ToastStates.ERROR,
            );
          }
          if (state is CreateNoticeSuccessState) {
            showToast(
              text: 'Successfully Added',
              state: ToastStates.SUCCESS,
            );
            //Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color(0xFFEDEDED),
            appBar: AppBar(
              
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TableBasicsExample()),
                          );
                },
              ),
              title: Text(""),
              backgroundColor: Colors.deepPurple,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [     
                       TextFormField( 
                               controller:  objController,
                              keyboardType:TextInputType.name, 
                               decoration: InputDecoration(
                                border: OutlineInputBorder(    
                                    borderRadius: BorderRadius.circular(10),
                                ),  
                                  labelText: "الموضوع",
                                 ),
                              validator: (value) {  
                                  if (value!.isEmpty)
                                  return 'لايجب ان يكون فارغ';    return null;
                              },),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField( 
                               controller: descriptionController,
                              keyboardType:TextInputType.multiline,
                              maxLines: 4, 
                               decoration: InputDecoration(
                                border: OutlineInputBorder(    
                                    borderRadius: BorderRadius.circular(10),
                                ),  
                                  labelText: "الوصف",
                                 ),
                              validator: (value) {  
                                  if (value!.isEmpty)
                                  return 'لايجب ان يكون فارغ';    return null;
                              },),
                                 
                        SizedBox(
                          height: 15.0,
                        ),
                      
                         TextFormField( 
                                   onTap: () {
                                    showTimePicker( 
                                      context: context,
                                    initialTime: selectedtime)
                                    .then((value) {   
                                         //timeController.text = value!.format(context).toString().replaceAll(' ', '');
                                      //  timeController.text ="${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
                                       if (value != null) {
      final formattedTime = '${value.hour}:${value.minute.toString().padLeft(2, '0')}';
      timeController.text = formattedTime;
                                            }}
                                            );
                              }, 
                               controller: timeController,
                              keyboardType: TextInputType.datetime, 
                               decoration: InputDecoration(
                                border: OutlineInputBorder(     
                                   borderRadius: BorderRadius.circular(10),
                                ),  
                                  labelText: "الوقت",
                                prefixIcon: Icon(Icons.access_time_outlined),  ),
                              validator: (value) {    if (value!.isEmpty)
                                  return 'لايجب ان يكون فارغ';    return null;
                              },),
                                      
      
                        SizedBox(
                          height: 15.0,
                        ),
                         TextFormField(
                                    onTap: () {   
                                       showDatePicker(context: context,
                                       locale:Locale('ar'),
                                        initialDate: DateTime.now(),     
                                         firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-01-01'),  ).then((value) {
                                        dateController.text = DateFormat('yyyy-M-d').format(value!).toString();
                                      });  },
                                    controller: dateController,  
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),    ),
                                      labelText: "التاريخ",  
                                        prefixIcon: Icon(Icons.date_range_outlined),
                                    ),  validator: (value) {
                                      if (value!.isEmpty)    
                                        return 'لا يجب ان يكون فارغاََ';
                                      return null;  },
                                  ),
                              
                                
                           SizedBox(
                          height: 15.0,
                        ),
                        

                        defaultButton(
                          function: () async {
                            String uid = AddNoticeCubit.get(context)
                                .generateRandomString();
                            var cubit = AddNoticeCubit.get(context);
                            if (formKey.currentState!.validate()) {
                                cubit.Add(
                                    obj: objController.text,
                                    description: descriptionController.text,
                                    date: dateController.text,
                                    time: timeController.text,
                                    uid: uid,
                                 //  token:''
                                    );
                              
                            }
                          },
                          text: 'اضافة',
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}