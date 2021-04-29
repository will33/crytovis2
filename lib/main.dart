import 'dart:convert';

import 'package:cryptovis2/profit_chart.dart';
import 'package:cryptovis2/profit_per_day.dart';
import 'package:cryptovis2/toggle_icons_icons.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'constants.dart';


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
  
  String _selectedProcessorType1 = 'GPU';
  String _selectedProcessorType2 = 'GPU';
  String _selectedProcessor1 = 'GTX 1080 Ti';
  String _selectedProcessor2 = 'GTX 1080 Ti';
  bool _enabledProcessor1 = true;
  bool _enabledProcessor2 = false;
  int _quantityProcessor1 = 1;
  int _quantityProcessor2 = 1;

  /// The selected electricity price, in kW/Hs.
  double _electricityPrice = 0.32;

  /// User inputed variable representing all of their other costs.
  double _otherFixedCosts = 0;

  /// User inputed variable representing their one-off capital costs
  double _otherCapitalExpenses = 0;

  /// User selected country to populate power prices.
  String _selectedCountry = 'Australia';
  
  final priceController = new TextEditingController();

  /// The selection state for the coin price history toggle widget. 
  /// 
  /// True indicates the coins history is visible, False indicates the coins 
  /// history is hidden. Index 0 is bitcoin. Index 1 is ethereum. 
  final List<bool> _coinHistorySelected = [false, false];

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
                      _electricityPrice = Constants.ELECTRICITY_PRICES[_selectedCountry];
                      priceController.text = _electricityPrice.toString();
                    });
                  },
                  items: Constants.ELECTRICITY_PRICES.keys
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
                  onChanged: (String newValue) {
                    setState(() {
                      if (newValue != "")
                        _electricityPrice = double.parse(newValue);
                    });
                  },
                )
              ]),
            ),
            Container(
              width: 50,
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
                    value: _selectedProcessorType1,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessorType1 = newValue;
                        _selectedProcessor1 =
                            Constants.PROCESSORS[_selectedProcessorType1].first;
                      });
                    },
                    items: Constants.PROCESSOR_TYPES
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
                  Text('Processor', style: TextStyle(color: Colors.green),),
                  DropdownButton(
                    value: Constants.PROCESSORS[_selectedProcessorType1]
                            .contains(_selectedProcessor1)
                        ? _selectedProcessor1
                        : Constants.PROCESSORS[_selectedProcessorType1].first,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessor1 = newValue;
                      });
                    },
                    items: Constants.PROCESSORS[_selectedProcessorType1]
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
                  Text('Quantity'),
                  Container(
                    width: 50,
                    child: TextFormField(
                      initialValue: _quantityProcessor1.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (String newValue) {
                        setState(() {
                          if (newValue != "")
                            _quantityProcessor1 = int.parse(newValue);
                        });
                      },
                    ),
                  )
                ],
              ),
              Container(
                width: 50,
              ),
              Column(
                children: [
                  Text('Enabled'),
                  Checkbox(value: _enabledProcessor1, onChanged: (bool newValue) {
                    setState(() {
                      _enabledProcessor1 = newValue;
                    });
                  })
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Processor type'),
                  DropdownButton(
                    value: _selectedProcessorType2,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessorType2 = newValue;
                        _selectedProcessor2 =
                            Constants.PROCESSORS[_selectedProcessorType2].first;
                      });
                    },
                    items: Constants.PROCESSOR_TYPES
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
                  Text('Processor', style: TextStyle(color: Colors.blue),),
                  DropdownButton(
                    value: Constants.PROCESSORS[_selectedProcessorType2]
                        .contains(_selectedProcessor2)
                        ? _selectedProcessor2
                        : Constants.PROCESSORS[_selectedProcessorType2].first,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedProcessor2 = newValue;
                      });
                    },
                    items: Constants.PROCESSORS[_selectedProcessorType2]
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
                  Text('Quantity'),
                  Container(
                    width: 50,
                    child: TextFormField(
                      initialValue: _quantityProcessor2.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (String newValue) {
                        setState(() {
                          if (newValue != "")
                            _quantityProcessor2 = int.parse(newValue);
                        });
                      },
                    ),
                  )
                ],
              ),
              Container(
                width: 50,
              ),
              Column(
                children: [
                  Text('Enabled'),
                  Checkbox(value: _enabledProcessor2, onChanged: (bool newValue) {
                    setState(() {
                      _enabledProcessor2 = newValue;
                    });
                  })
                ],
              ),
            ],
          ),
          getProfitChart(365),
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
                  get30DayPriceChart('bitcoin'),
                ],
              )),
          Visibility(
              visible: _ethereumVisible,
              child: Column(
                children: [
                  Text('Ethereum Price History'),
                  get30DayPriceChart('ethereum'),
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
  Widget getProfitChart(int numberOfDays) {
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
            DateTime startDate =
                DateTime.now().subtract(Duration(days: numberOfDays));
            List<ProfitPerDay> seriesProcessor1 = [];
            List<ProfitPerDay> seriesProcessor2 = [];
            double sumProcessor1 = _otherCapitalExpenses * -1;
            double sumProcessor2 = _otherCapitalExpenses * -1;

            // Go through each value on the priceHistoryRequest per day. The
            // first value in the response is the oldest, the last is the
            // current price.
            Map<String, dynamic> response = jsonDecode(snapshot.data.body);
            for (int i = 0; i < numberOfDays; i++) {
              double coinPrice = response['prices'][i][1];
              double profitProcessor1 = 0.0;
              double profitProcessor2 = 0.0;
              
              profitProcessor1 = calculateProfitForDay(coinPrice, _selectedProcessor1);
              profitProcessor2 = calculateProfitForDay(coinPrice, _selectedProcessor2);

              sumProcessor1 += profitProcessor1 * _quantityProcessor1;
              sumProcessor2 += profitProcessor2 * _quantityProcessor2;

              if (_enabledProcessor1)
                seriesProcessor1.add(ProfitPerDay(
                  startDate.add(Duration(days: i)),
                  sumProcessor1,
                  profitProcessor1 >= 0 ? Colors.green : Colors.redAccent,
                ));

              if (_enabledProcessor2)
                seriesProcessor2.add(ProfitPerDay(
                  startDate.add(Duration(days: i)),
                  sumProcessor2,
                  profitProcessor2 >= 0 ? Colors.blue : Colors.red,
                ));
            }
            List<List<ProfitPerDay>> series = [seriesProcessor1, seriesProcessor2];
            return ProfitChart(series, 'Time', 'Profit (AU\$)');
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container();
          }
        });
  }

  /// Returns the amount of profit made for a specific day.
  double calculateProfitForDay(double coinPrice, String processor) {
    return calculateIncomeForDay(coinPrice, processor) - calculateCostForDay(processor);
  }

  /// Returns the cost (in electricity) for 24 hours of use.
  double calculateCostForDay(String processor) {
    return (_electricityPrice / Constants.WATTS_IN_KILOWATT) *
            Constants.HOURS_IN_DAY *
            Constants.POWER_USAGES[processor] +
        _otherFixedCosts;
  }

  /// Returns the income generated from 24 hours of hashing.
  double calculateIncomeForDay(double coinPrice, String processor) {
    return Constants.BITCOIN_BLOCK_REWARD * (Constants.MINUTES_IN_DAY / Constants.BITCOIN_AVG_BLOCKTIME) *
        (Constants.HASH_RATES[processor] / Constants.NETWORK_HASHRATE) * coinPrice;
  }

  /// Builds a graph displaying the price history of a [coin] for the past 30
  /// days.
  Widget get30DayPriceChart(String coin) {
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
            return ProfitChart([priceSeries], 'Time', 'Price (AU\$)');
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
