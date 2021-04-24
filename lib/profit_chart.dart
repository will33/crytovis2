import 'package:cryptovis2/profit_per_day.dart';
import 'package:flutter/cupertino.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class ProfitChart extends StatefulWidget {
  ProfitChart(this.chartData, this.xLabel, this.yLabel);

  final List<ProfitPerDay> chartData;
  final String xLabel;
  final String yLabel;

  @override
  _ProfitChartState createState() => _ProfitChartState();
}

class _ProfitChartState extends State<ProfitChart> {
  DateTime _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.day;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.profit;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {

    var series = [
      new charts.Series(
        id: 'Profit',
        domainFn: (ProfitPerDay clickData, _) => clickData.day,
        measureFn: (ProfitPerDay clickData, _) => clickData.profit,
        colorFn: (ProfitPerDay clickData, _) => clickData.color,
        data: widget.chartData,
      ),
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      behaviors: [
        new charts.ChartTitle(widget.xLabel,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle(widget.yLabel,
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea)
      ],
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      animate: true,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    
    final children = <Widget>[
      chartWidget
    ];

    if (_time != null)
      children.add(Text(_time.toString()));
    _measures?.forEach((series, value) {
      children.add(new Text('$series: \$${value.toStringAsFixed(2)}'));
    });
    
    return Container(
      child: Column(
        children: children
      ),
    );
  }
}