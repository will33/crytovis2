import 'package:cryptovis2/profit_per_day.dart';
import 'package:flutter/cupertino.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class ProfitChart extends StatelessWidget {
  ProfitChart(this.chartData);

  final List<ProfitPerDay> chartData;
  @override
  Widget build(BuildContext context) {

    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ProfitPerDay clickData, _) => clickData.day,
        measureFn: (ProfitPerDay clickData, _) => clickData.profit,
        colorFn: (ProfitPerDay clickData, _) => clickData.color,
        data: chartData,
      ),
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      behaviors: [
        new charts.ChartTitle('Forecast',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Profit (\$)',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea)
      ],
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
      animate: true,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    return Container(
      child: chartWidget,
    );
  }
}