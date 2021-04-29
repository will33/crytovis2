import 'dart:convert';

import 'package:cryptovis2/profit_chart.dart';
import 'package:cryptovis2/profit_per_day.dart';
import 'package:cryptovis2/toggle_icons_icons.dart';
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
  /// Determines if Bitcoin price chart is shown. Defaults to false.
  bool _bitcoinVisible = false;

  /// Determines if Ethereum price chart is shown. Defaults to false.
  bool _ethereumVisible = false;

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

  /// The selected electricity price, in kW/Hs.
  double _electricityPrice = 0.32;

  /// User inputed variable representing all of their other costs.
  double _otherFixedCosts = 0;

  /// User inputed variable representing their one-off capital costs
  double _otherCapitalExpenses = 0;

  /// User selected country to populate power prices.
  String _selectedCountry = 'Australia';

  /// The electricity price of each country, in kW/Hs. Sourced from Statista,
  /// current as of September 2020. https://www.statista.com/aboutus/trust
  var _electricityPrices = {
    'Australia': 0.32,
    'Argentina': 0.077,
    'Belgium': 0.39,
    'Brazil': 0.15,
    'China': 0.1,
    'Cyprus': 0.27,
    'Denmark': 0.42,
    'France': 0.28,
    'Germany': 0.46,
    'India': 0.1,
    'Indonesia': 0.13,
    'Iran': 0.013,
    'Ireland': 0.35,
    'Italy': 0.33,
    'Kenya': 0.27,
    'Japan': 0.33,
    'Mexico': 0.1,
    'New Zealand': 0.31,
    'Nigeria': 0.077,
    'Poland': 0.24,
    'Portugal': 0.35,
    'Qatar': 0.039,
    'Russia': 0.077,
    'Rwanda': 0.33,
    'Saudi Arabia': 0.064,
    'Singapore': 0.21,
    'South Africa': 0.19,
    'Spain': 0.31,
    'Turkey': 0.12,
    'UK': 0.33,
    'USA': 0.19,
  };

  final priceController = new TextEditingController();

  static const int HOURS_IN_DAY = 24;
  static const int WATTS_IN_KILOWATT = 1000;

  /// The processor to return the profitability for.
  String _selectedProcessor = 'GTX 1080 Ti';

  /// The selection state for the coin price history toggle widget. 
  /// 
  /// True indicates the coins history is visible, False indicates the coins 
  /// history is hidden. Index 0 is bitcoin. Index 1 is ethereum. 
  final List<bool> _coinHistorySelected = [false, false];

  // the Scenario start time
  DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    priceController.text = _electricityPrice.toStringAsFixed(2);

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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text('Country'),
                DropdownButton(
                  value: _selectedCountry,
                  onChanged: (String newCountry) {
                    setState(() {
                      _selectedCountry = newCountry;
                      _electricityPrice = _electricityPrices[_selectedCountry];
                      priceController.text = _electricityPrice.toString();
                    });
                  },
                  items: _electricityPrices.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(width: 50),
            Container(
              width: 150,
              child: Column(children: [
                Text("Electricity Price \$/kwH"),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String newValue) {
                    setState(() {
                      _electricityPrice = double.parse(newValue);
                    });
                  },
                )
              ]),
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 150,
              child: Column(children: [
                Text('Select starting date'),
                InputDatePickerFormField(
                    firstDate: DateTime.now().subtract(Duration(days: 3650)),
                    lastDate: DateTime.now().add(Duration(days:365)),
                    onDateSubmitted: (DateTime newDate){
                      setState(() {
                        _startDate = newDate;
                      });
                  },

                )
              ])
            )
          ]),
          Container(height: 50),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 150,
              child: Column(children: [
                Text("Other Fixed Costs"),
                TextFormField(
                  initialValue: _otherFixedCosts.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue) {
                    setState(() {
                      _otherFixedCosts = double.parse(newValue);
                    });
                  },
                )
              ]),
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 150,
              child: Column(children: [
                Text("Other Initial Capital Expenses"),
                TextFormField(
                  initialValue: _otherCapitalExpenses.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue) {
                    setState(() {
                      _otherCapitalExpenses = double.parse(newValue);
                    });
                  },
                )
              ]),
            )
          ]),
          Container(height: 50),
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
          getProfitChart(365, 'bitcoin'), // TODO: don't hardcode either
          // This button toggles if we should show the price history of the
          // coins.
          Text('Display Price History of the coins in AUD'),
          ToggleButtons(
            children: <Widget>[
              Icon(ToggleIcons.bitcoin),
              Icon(ToggleIcons.ethereum),
            ],
            onPressed: (int index) {
              setState(() {
                _coinHistorySelected[index] = !_coinHistorySelected[index];
                if (index == 0) {
                  _bitcoinVisible = !_bitcoinVisible;
                } else {
                  _ethereumVisible = !_ethereumVisible;
                }
              });
            },
            isSelected: _coinHistorySelected,
          ),
          Visibility(
              visible: _bitcoinVisible,
              child: Column(
                children: [
                  Text('Bitcoin Price History'),
                  getPriceChart('bitcoin'),
                ],
              )),
          Visibility(
              visible: _ethereumVisible,
              child: Column(
                children: [
                  Text('Ethereum Price History'),
                  getPriceChart('ethereum'),
                ],
              )),
        ],
      )),
    );
  }

  /// Builds a graph displaying the daily profit of a particular processor in a
  /// particular country.
  ///
  /// The [numberOfDays] is the amount of days to populate the chart with.
  Widget getProfitChart(int numberOfDays, String coin) {
    // we now get a range of dates explicitly
    var startingDate = _startDate;
    var nDaysAgo = DateTime.now().subtract(Duration(days: numberOfDays));
    if (startingDate.isAfter(nDaysAgo)){
      startingDate = nDaysAgo;
    }
    var endingDate = startingDate.add(Duration(days: numberOfDays));
    if (endingDate.isAfter(DateTime.now())){
      endingDate = DateTime.now();
    }

    final priceHistoryRequest = http.get(Uri.https('api.coingecko.com',
        'api/v3/coins/$coin/market_chart/range', <String, String>{
      'vs_currency': 'aud',
      // 'days': numberOfDays.toString(),
      // 'interval': 'daily'
          'from': (startingDate.millisecondsSinceEpoch/1000).toString(),
          'to': (endingDate.millisecondsSinceEpoch/1000).toString()
    }));

    return FutureBuilder<http.Response>(
        future: priceHistoryRequest,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            DateTime startDate = startingDate;

            List<ProfitPerDay> series = [];
            double sum = _otherCapitalExpenses * -1;
            double profit = 0.0;
            Color colour = Colors.red;
            // Go through each value on the priceHistoryRequest per day. The
            // first value in the response is the oldest, the last is the
            // current price.
            Map<String, dynamic> response = jsonDecode(snapshot.data.body);
            for (int i = 0; i < numberOfDays; i++) {
              double coinPrice = response['prices'][i][1];
              profit = calculateProfitForDay(coinPrice);

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
            return ProfitChart(series, 'Time', 'Profit (AU\$)');
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container();
          }
        });
  }

  /// Returns the amount of profit made for a specific day.
  double calculateProfitForDay(double coinPrice) {
    return calculateIncomeForDay(coinPrice) - calculateCostForDay();
  }

  /// Returns the cost (in electricity) for 24 hours of use.
  double calculateCostForDay() {
    return (_electricityPrice / WATTS_IN_KILOWATT) *
            HOURS_IN_DAY *
            _powerUsages[_selectedProcessor] +
        _otherFixedCosts;
  }

  /// Returns the income generated from 24 hours of hashing.
  double calculateIncomeForDay(double coinPrice) {
    return 6.25 * // Amount of bitcoins given as a reward.
        (1440 / 10) * // Minutes in a day divide the BTC blocktime in minutes
        (_hashRates[_selectedProcessor] / // The processor hashrate.
            149045000) * // BTC network hashrate. TODO: See if Blockchain.com has an api.
        coinPrice; // The price of BTC on that day.
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
