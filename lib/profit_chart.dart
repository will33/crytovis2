import 'package:cryptovis2/profit_per_day.dart';
import 'package:flutter/cupertino.dart';

import 'package:charts_flutter/flutter.dart' as charts;

/// A chart mapping multiple [ProfitPerDay] objects on a graph. 
class ProfitChart extends StatefulWidget {
  /// Initialises a [ProfitChart] object. 
  /// 
  /// [chartData] is the list of [ProfitPerDay] objects to be displayed.
  /// [xLabel] and [yLabel] are, predictably, the labels for the x and y axes. 
  ProfitChart(this.chartData, this.xLabel, this.yLabel);

  /// The list of [ProfitPerDay] objects to be displayed in this [ProfitChart].
  final List<ProfitPerDay> chartData;
  /// The label for the x-axis.
  final String xLabel;
  /// The label for the y-axis.
  final String yLabel;

  @override
  _ProfitChartState createState() => _ProfitChartState();
}

/// Stores the state of the [ProfitChart].
class _ProfitChartState extends State<ProfitChart> {
  /// The day the selection was last changed.
  DateTime _time;
  /// TODO
  Map<String, num> _measures;

  /// Updates the profit charts state when an input changes.
  _onSelectionChanged(charts.SelectionModel model) {
    /// The newly selected datum from this [model].
    final selectedDatum = model.selectedDatum;
    /// The day the selection was changed.
    DateTime time;
    /// TODO: I don't know what a 'measures' is. Is it the chartData?
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