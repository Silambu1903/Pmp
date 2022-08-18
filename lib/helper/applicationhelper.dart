import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplicationHelper {
  dateFormatter(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  timeFormatter(DateTime date) {
    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(date);
    return formatted;
  }

  timeFormatter2(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');
    final String formatted = formatter.format(date);
    return formatted;
  }
  dateFormatter1(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    final String formatted = formatter.format(date);
    return formatted;
  }

  dateFormatter4(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }


  dateFormatter2(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MMMM');
    final String formatted = formatter.format(date);
    return formatted;
  }
  stringtodate(String date){
    final DateFormat formatter = DateFormat('yyyy - MMM');
    DateTime formatted = DateTime.parse(date);
    var convertedDate = formatter.format(formatted);
    return convertedDate;
  }


}