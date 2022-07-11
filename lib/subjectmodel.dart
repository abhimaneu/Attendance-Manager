import 'dart:math';

import 'package:attendencemanager/subject_details.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'subjectmodel.g.dart';

@HiveType(typeId: 0)
class subject_Model{
  @HiveField(0)
  var days;
  @HiveField(1)
  var name;
  @HiveField(2)
  var presnetdaysinhive;
  @HiveField(3)
  var absentdaysinhive;

  subject_Model({this.days,this.name,this.presnetdaysinhive,this.absentdaysinhive});
}

Future puttotalsubjects(boxname,totalnumber) async{
  late Box box;
  box  = await Hive.openBox('$boxname');
  box.put('n', totalnumber);
}

Future gettotalsubjects(boxname) async{
  late Box box;
  box = await Hive.openBox('$boxname');
  var subjectnumber = box.get('n');
  if(subjectnumber!=null){
    return subjectnumber;
  }
  else{
    return 101010;
  }
}

Future storedays(String name,days) async{
  late Box box;
    box = await Hive.openBox('$name');
  box.put('days', days);
  print(box.get('days'));
  print(box);
}

Future<int> getdays(String name) async{
  late Box box;
    box = await Hive.openBox('$name');
  var days = box.get('days');
  if(days!=null){
    return days;
  }
  else{
    return 0;
  }
}

Future putdata(Name,p,a,id,boxname) async{
  Box box = await Hive.openBox('$boxname');
  box.put(id, subject_Model(name: Name,presnetdaysinhive: p,absentdaysinhive: a));
  print(box.get(id));
}

Future getdata(id,boxname) async{
  Box box = await Hive.openBox('$boxname');
  late subject_Model subjectModel;
  if(box.get(id)!=null) {
    subjectModel = await box.get(id);
    print(subjectModel.name);
  }
    return subjectModel;
}
Future removedata(id,boxname) async{
  Box box = await Hive.openBox('$boxname');
  box.delete(id);
}

Future putid(i,nametostore) async{
  Box box = await Hive.openBox('ids');
  box.put(i,nametostore);
  print("called");
}

Future getid(i) async{
  Box box = await Hive.openBox('ids');
  var s = box.get(i);
  if(s!=null) {
    return s;
  }
  else{
    return 'novalue';
  }
}

Future removeid(id,namefordelete)async{
  Box box = await Hive.openBox('ids');
  int i=0;
  while(i<=id){
    if((box.get(i))==namefordelete){
      box.delete(i);
      break;
    }
    i=i+1;
  }
}

Future storingdata(subject_details subject,index) async{
  Box box = await Hive.openBox('data');
  int i=0;
  while(i<=index){
    box.put(i, subject);
    print("d${box.get(0)}");
    i=i+1;
  }
}

Future getstoringdata(index) async{
  Box box = await Hive.openBox('data');
  //subject_details subject = await box.get(index);
  //return subject;
}

Future putlast(index,lastaction) async{
  Box box = await Hive.openBox('lastdata');
  box.put(index, lastaction);
}

Future getlast(index) async{
  Box box = await Hive.openBox('lastdata');
  var lastaction= " ";
  try{
    lastaction = box.get(index);
  }
  catch(e){
    lastaction = " ";
  }
  finally{
    return lastaction;
  }
}