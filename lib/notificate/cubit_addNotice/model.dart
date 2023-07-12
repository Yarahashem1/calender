class AddNoticeModel {
  String? obj;
  String? description;
  String? date;
  String? time;
  String? uid;
  

  AddNoticeModel({
    this.obj,
    this.description,
    this.uid,
    this.date,
     this.time,
  });

  AddNoticeModel.fromJson(Map<String, dynamic>? json)
  {
    obj = json!['obj'];
    description = json['description'];
    uid = json['uid'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'obj':obj,
      'description':description,
      'uid':uid,
      'date':date,
     'time':time,
    };
  }
  }