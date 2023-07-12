
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/notificate/cubit_addNotice/state.dart';

import 'model.dart';


class AddNoticeCubit extends Cubit<AddNoticetates> {
  AddNoticeCubit() : super(AddNoticeInitialState());
  
  static AddNoticeCubit get(context) => BlocProvider.of(context);



void Add({
    required String obj,
    required String description,
    required String date,
    required String uid,
     required String time,
  }) {
    emit(AddNoticeLoadingState());
    NoticeCreate(
      obj: obj,
      description: description,
      date: date,
      uid: uid,
      time:time
    );
  }

  void NoticeCreate({
    required String obj,
    required String description,
    required String date,
    required String time,
    required String uid,
  }) {
    AddNoticeModel model = AddNoticeModel(
      uid: uid,
      obj: obj,
      description: description,
      date: date,
    );
    FirebaseFirestore.instance
        .collection('notific')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      emit(CreateNoticeSuccessState());
    }).catchError((error) {
      emit(CreateNoticeErrorState(error));
    });
  }
   String? newValue;
  String category(String? val){
    newValue =val!;
     emit(categorySuccessState());
      return newValue!;
  }



  String generateRandomString() {
  final random = Random();
  const letters = 'abcdefghijklmnopqrstuvwxyz';
  final codeUnits = List.generate(3, (index) {
    final index = random.nextInt(letters.length);
    return letters.codeUnitAt(index);
  });
  return String.fromCharCodes(codeUnits);
}
}