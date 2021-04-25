import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;

/// A representation of the amount of profit made in a single day.
class ProfitPerDay {
  /// The day the object is representing the data for. 
  DateTime day;
  /// The profit made on the day.
  double profit;
  /// The colour that the data point should be coloured on a [ProfitChart].
  final charts.Color color;

  /// Initialises a [ProfitPerDay] object. 
  /// 
  /// A [day] is the day the profit was realised, [profit] is the amount of 
  /// profit realised and [color] is the colour that the data point should be 
  /// coloured on a graph.
  ProfitPerDay(this.day, this.profit, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
