import 'package:flutter/material.dart';

class subject_details{

  var name;
  var present_days;
  var absent_days;
  var total_days;
  var attendence_percentage;
  var last_action="";
  var statusString="";
  Color coloroftile = Colors.white;

  subject_details({this.absent_days,this.name,this.present_days});

  void totalDays(){
    total_days=present_days+absent_days;
  }
  int gettotalDays(){
    return total_days = present_days+absent_days;
  }
  void subjectpercentage(){
    attendence_percentage=(present_days/total_days)*100;
  }
  double getsubjectpercentage(){
    if(total_days==0){
      return 0.0;
    }

    gettotalDays();
    attendence_percentage=(present_days/total_days)*100;
    return attendence_percentage;
  }
  lastactionset(r){
    if (r==1){
      last_action=last_action+"1";
    }
    if (r==0){
      last_action=last_action+"0";
    }
  }
}


