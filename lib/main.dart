import 'dart:math';

import 'package:cryptovis2/profit_chart.dart';
import 'package:cryptovis2/profit_per_day.dart';
import 'package:flutter/material.dart';

import 'package:global_configuration/global_configuration.dart';

void main() async {
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoVis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "fl utter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CryptoVis Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _processorTypes = ['ASIC', 'GPU', 'CPU'];
  String _selectedProcessorType = 'GPU';
  var _processors = {
    'ASIC': ['AntMiner', 'AC130', 'SPS320'],
    'GPU': ['GTX 1080 Ti', 'RTX 2070S', 'RX 480'],
    'CPU': ['i7 7700k', 'i5 3750k', '5700X']
  };

  // in Watts
  var _powerUsages = {
    'AntMiner': 1000,
    'AC130': 800,
    'SPS320': 900,
    'GTX 1080 Ti': 500,
    'RTX 2070S': 400,
    'RX 480': 300,
    'i7 7700k': 180,
    'i5 3750k': 100,
    '5700X': 200
  };

  // in MH/s
  var _hashRates = {
    'AntMiner': 700,
    'AC130': 800,
    'SPS320': 900,
    'GTX 1080 Ti': 45.69,
    'RTX 2070S': 43,
    'RX 480': 30.29,
    'i7 7700k': 5,
    'i5 3750k': 4,
    '5700X': 6
  };

  // in price / Wh
  double _electricityPrice = 0.0002;
  double _moneyPerMegahash = 5 / 3600;
  int _hoursInMonth = 24 * 30;

  String _selectedProcessor = 'GTX 1080 Ti';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Calculate Economics'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Processor type'),
                  DropdownButton(
                    value: _selectedProcessorType,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessorType = newValue;
                        _selectedProcessor = _processors[_selectedProcessorType].first;
                      });
                    },
                    items: _processorTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
              Container(
                width: 50,
              ),
              Column(
                children: [
                  Text('Processor'),
                  DropdownButton(
                    value: _processors[_selectedProcessorType].contains(_selectedProcessor)
                        ? _selectedProcessor
                        : _processors[_selectedProcessorType].first,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessor = newValue;
                      });
                    },
                    items: _processors[_selectedProcessorType].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
            ],
          ),
          ProfitChart(getChartForDateRange(DateTime.now(), 90))
        ],
      )),
    );
  }

  List<ProfitPerDay> getChartForDateRange(DateTime startDate, int numberOfDays) {
    List<ProfitPerDay> series = [];
    double sum = 0;
    var rng = Random();
    for (int i = 0; i < numberOfDays; i++) {
      sum += calculateCostForDay();
      series.add(ProfitPerDay(startDate.add(Duration(days: i)), sum + rng.nextInt(20), Colors.red));
    }
    return series;
  }

  double calculateProfitPerDay() {
    return calculateIncomeForDay() - calculateCostForDay();
  }

  double calculateCostForDay() {
    return _electricityPrice * 24 * _powerUsages[_selectedProcessor];
  }

  double calculateIncomeForDay() {
    return _moneyPerMegahash * 24 * _hashRates[_selectedProcessor];
  }
}
