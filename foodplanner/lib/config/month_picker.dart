// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class MonthPicker {
  static String pick(int? monthIndex) {
    if(monthIndex == 1) return 'januar';
    else if(monthIndex == 2) return 'februar';
    else if(monthIndex == 3) return 'marts';
    else if(monthIndex == 4) return 'april';
    else if(monthIndex == 5) return 'maj';
    else if(monthIndex == 6) return 'juni';
    else if(monthIndex == 7) return 'juli';
    else if(monthIndex == 8) return 'august';
    else if(monthIndex == 9) return 'september';
    else if(monthIndex == 10) return 'oktober';
    else if(monthIndex == 11) return 'november';
    else if(monthIndex == 12) return 'december';
    return '';
  }
}