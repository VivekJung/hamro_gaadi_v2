import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeExtractor {
  DateTime date = DateTime.now();

  int getDayAsInteger(int indexForWeek) {
    String dateFormat = DateFormat('EEEE').format(date);
    if (dateFormat == "Sunday") {
      indexForWeek = 0;
    } else if (dateFormat == "Monday") {
      indexForWeek = 1;
    } else if (dateFormat == "Tuesday") {
      indexForWeek = 2;
    } else if (dateFormat == "Wednesday") {
      indexForWeek = 3;
    } else if (dateFormat == "Thursday") {
      indexForWeek = 4;
    } else if (dateFormat == "Friday") {
      indexForWeek = 5;
    } else if (dateFormat == "Saturday") {
      indexForWeek = 6;
    } else {
      throw UnimplementedError("Coldn't get the date.. let's check");
    }

    return indexForWeek;
  }

  int getThisMonthAsInteger() {
    var d = int.tryParse(DateFormat('MM').format(date)) ?? 1;
    return d - 1;
  }

  int getMonthAsInteger(int indexForMonth) {
    // log("indexForthis month is  $indexForMonth");
    String monthFormat = DateFormat('MMMM').format(date);

    if (monthFormat == "January") {
      indexForMonth = 0;
    } else if (monthFormat == "February") {
      indexForMonth = 1;
    } else if (monthFormat == "March") {
      indexForMonth = 2;
    } else if (monthFormat == "April") {
      indexForMonth = 3;
    } else if (monthFormat == "May") {
      indexForMonth = 4;
    } else if (monthFormat == "June") {
      indexForMonth = 5;
    } else if (monthFormat == "July") {
      indexForMonth = 6;
    } else if (monthFormat == "August") {
      indexForMonth = 7;
    } else if (monthFormat == "September") {
      indexForMonth = 8;
    } else if (monthFormat == "October") {
      indexForMonth = 9;
    } else if (monthFormat == "November") {
      indexForMonth = 10;
    } else if (monthFormat == "December") {
      indexForMonth = 11;
    }
    return indexForMonth;
  }
}

formatTimestamp(Timestamp timestamp) {
  String convertedDate;
  convertedDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());
  return convertedDate;
}
