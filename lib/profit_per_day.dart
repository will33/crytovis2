import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;

class ProfitPerDay {
  DateTime day;
  double profit;
  final charts.Color color;

  ProfitPerDay(this.day, this.profit, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
