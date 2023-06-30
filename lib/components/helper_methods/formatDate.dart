import 'package:cloud_firestore/cloud_firestore.dart';


//DateTime.parse("2021-12-23 11:47:00");
String formatDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  String formattedDate = '$day/$year/$month';

  return formattedDate;
}