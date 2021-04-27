import 'dart:convert';

import 'package:cryptovis2/profit_chart.dart';
import 'package:cryptovis2/profit_per_day.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

/// The root of the CryptoVis application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoVis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
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

/// The home page of the static site.
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  /// The title of the webpage, often displayed in the tab in the browser.
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// Stores the state of the [MyHomePage].
class _MyHomePageState extends State<MyHomePage> {
  /// The processor types used to populate the second dropdown box.
  var _processorTypes = ['ASIC', 'GPU', 'CPU'];

  /// The processor type selected from [_processorTypes].
  String _selectedProcessorType = 'GPU';

  /// The list of processors the app can check against.
  var _processors = {
    'ASIC': ['AntMiner', 'AC130', 'SPS320'],
    'GPU': ['GTX 1080 Ti', 'RTX 2070S', 'RX 480'],
    'CPU': ['i7 7700k', 'i5 3750k', '5700X']
  };

  /// The power usage of each processor, in Watts.
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

  /// The hash rate of each processor in MH/s
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

  /// The electricity price of each country, in W/Hs.
  double _electricityPrice = 0.00032;

  /// The electricity price of each country, in W/Hs.
  var _electricityPrices = {
    'Australia': 0.00032,
    'Argentina': 0.000077,
    'Belgium': 0.00039,
    'Brazil': 0.00015,
    'China': 0.0001,
    'Cyprus': 0.00027,
    'Denmark': 0.00042,
    'France': 0.00028,
    'Germany': 0.00046,
    'India': 0.0001,
    'Indonesia': 0.00013,
    'Iran': 0.000013,
    'Ireland': 0.00035,
    'Italy': 0.00033,
    'Kenya': 0.00027,
    'Japan': 0.00033,
    'Mexico': 0.0001,
    'New Zealand': 0.00031,
    'Nigeria': 0.000077,
    'Poland': 0.00024,
    'Portugal': 0.00035,
    'Qatar': 0.000039,
    'Russia': 0.000077,
    'Rwanda': 0.00033,
    'Saudi Arabia': 0.000064,
    'Singapore': 0.00021,
    'South Africa': 0.00019,
    'Spain': 0.00031,
    'Turkey': 0.00012,
    'UK': 0.00033,
    'USA': 0.00019,
  };

  /// The price of the coin being calculated (atm, just BTC).
  double _coinPrice = 0.0; // This cannot be set here, as it changes per day.

  /// The hours in the month being displayed.
  // ignore: unused_field
  int _hoursInMonth = 24 * 30;

  /// The processor to return the profitability for.
  String _selectedProcessor = 'GTX 1080 Ti';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
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
      body: SingleChildScrollView(
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
                        _selectedProcessor =
                            _processors[_selectedProcessorType].first;
                      });
                    },
                    items: _processorTypes
                        .map<DropdownMenuItem<String>>((String value) {
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
                    value: _processors[_selectedProcessorType]
                            .contains(_selectedProcessor)
                        ? _selectedProcessor
                        : _processors[_selectedProcessorType].first,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessor = newValue;
                      });
                    },
                    items: _processors[_selectedProcessorType]
                        .map<DropdownMenuItem<String>>((String value) {
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
          getProfitChart(90),
          //Text('Bitcoin Price History'),
          //getPriceChart('bitcoin'),
          //Text('Ethereum Price History'),
          //getPriceChart('ethereum')
        ],
      )),
    );
  }

  /// Builds a graph displaying the daily profit of a particular processor in a
  /// particular country.
  ///
  /// The [numberOfDays] is the amount of days to populate the chart with.
  Widget getProfitChart(int numberOfDays) {
    DateTime startDate = DateTime.now();
    startDate = startDate.subtract(Duration(days: numberOfDays));
    List<ProfitPerDay> series = [];
    double sum = 0.0;
    double profit = 0.0;
    Color colour = Colors.red;

    final priceHistoryRequest = http.get(Uri.https('api.coingecko.com',
        'api/v3/coins/bitcoin/market_chart', <String, String>{
      'vs_currency': 'aud',
      'days': numberOfDays.toString(),
      'interval': 'daily'
    }));

    return FutureBuilder<http.Response>(
        future: priceHistoryRequest,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            // Go through each value on the priceHistoryRequest per day. The
            // first value in the response is the oldest, the last is the
            // current price.
            for (int i = 0; i < numberOfDays; i++) {
              Map<String, dynamic> response = jsonDecode(snapshot.data.body);
              _coinPrice = response['prices'][i][1];
              profit = calculateProfitForDay();

              // Colour code the addition to the chart.
              if (profit >= 0) {
                colour = Colors.green;
              } else {
                colour = Colors.red;
              }

              // Add the result to the chart.
              sum += profit;
              series.add(ProfitPerDay(
                startDate.add(Duration(days: i)),
                sum,
                colour,
              ));
            }
            return ProfitChart(series, 'Time', 'Price (AU\$)');
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container();
          }
        });
  }

  /// Returns the amount of profit made for a specific day.
  double calculateProfitForDay() {
    return calculateIncomeForDay() - calculateCostForDay();
  }

  /// Returns the cost (in electricity) for 24 hours of use.
  double calculateCostForDay() {
    return _electricityPrice * 24 * _powerUsages[_selectedProcessor];
  }

  /// Returns the income generated from 24 hours of hashing.
  double calculateIncomeForDay() {
    return 6.25 * // Amount of bitcoins given as a reward.
        (1440 / 10) * // Minutes in a day divide the BTC blocktime in minutes
        (_hashRates[_selectedProcessor] / // The processor hashrate.
            149045000) * // BTC network hashrate. TODO: See if Blockchain.com has an api.
        _coinPrice; // The price of BTC on that day.
  }

  /// Builds a graph displaying the price history of a [coin] for the past 30
  /// days.
  Widget getPriceChart(String coin) {
    final priceHistoryRequest = http.get(Uri.https('api.coingecko.com',
        'api/v3/coins/$coin/market_chart', <String, String>{
      'vs_currency': 'aud',
      'days': '30',
      'interval': 'daily'
    }));
    return FutureBuilder<http.Response>(
        future: priceHistoryRequest,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            var priceSeries = getPriceSeries(snapshot.data.body);
            return ProfitChart(priceSeries, 'Time', 'Price (AU\$)');
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container();
          }
        });
  }

  /// Returns a series of prices contained within a JSON string [data].
  List<ProfitPerDay> getPriceSeries(String data) {
    var json = jsonDecode(data);
    var prices = json['prices'];
    var series = <ProfitPerDay>[];
    prices.forEach((element) => series.add(ProfitPerDay(
        DateTime.fromMillisecondsSinceEpoch(element[0]),
        element[1],
        Colors.blue)));
    return series;
  }
}
