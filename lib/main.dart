import 'dart:convert';

import 'package:async/async.dart';
import 'package:cryptovis2/profit_chart.dart';
import 'package:cryptovis2/profit_per_day.dart';
import 'package:cryptovis2/toggle_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import 'package:http/http.dart' as http;

import 'constants.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

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
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'CryptoVis'),
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

class ProcessorSet {
  String processorType = 'GPU';
  String processor = 'GTX 1080 Ti';
  bool enabled = true;
  int quantity = 1;
  bool alreadyPurchased = false;
}

/// Stores the state of the [MyHomePage].
class _MyHomePageState extends State<MyHomePage> {
  /// Determines if Bitcoin price chart is shown. Defaults to false.
  bool _bitcoinVisible = true;

  /// Determines if Ethereum price chart is shown. Defaults to false.
  bool _ethereumVisible = false;

  ProcessorSet _processorSet1 = ProcessorSet();
  ProcessorSet _processorSet2 = ProcessorSet();

  final AsyncMemoizer<http.Response> _historicalMemoizer = AsyncMemoizer();


  // String _selectedProcessorType1 = 'GPU';
  // String _selectedProcessorType2 = 'GPU';
  // String _selectedProcessor1 = 'GTX 1080 Ti';
  // String _selectedProcessor2 = 'GTX 1080 Ti';
  // bool _enabledProcessor1 = true;
  // bool _enabledProcessor2 = false;
  // int _quantityProcessor1 = 1;
  // int _quantityProcessor2 = 1;

  /// The selected electricity price, in kW/Hs.
  double _electricityPrice = 0.32;

  /// User inputed variable representing all of their other costs.
  double _otherFixedCosts = 0;

  /// User inputed variable representing their one-off capital costs
  double _otherCapitalExpenses = 0;

  /// User selected country to populate power prices.
  String _selectedCountry = 'Australia';

  final priceController = new TextEditingController();

  /// The crypto coin to use in the tool.
  ///
  /// True indicates the coin is active, False indicates the coins is inactive.
  /// Only one coin can be active at a time. Index 0 is bitcoin.
  /// Index 1 is ethereum. Must be a List<bool> and not a string so it can be
  /// use as the `isSelected` option in the [ToggleButton] widget.
  final List<bool> _coinSelected = [true, false];

  // the Scenario start time
  DateTime _startDate = DateTime.now();
  int _chartNumberOfDays = 365;

  double _chartWidth = 610;

  bool isSwitched = false;

  // This is for efficiency. On startup, the app fetches 2 years of prices for BTC and caches. All subsequent requests use the cached results.
  Future<http.Response> _fetchData() {
    return this._historicalMemoizer.runOnce(() async {
      return http.get(Uri.https('api.coingecko.com',
          'api/v3/coins/bitcoin/market_chart/range', <String, String>{
            'vs_currency': 'aud',
            'from': (DateTime.now().add(Duration(days: -Constants.DAYS_IN_TWO_YEARS)).millisecondsSinceEpoch / 1000).toString(),
            'to': (DateTime.now().millisecondsSinceEpoch / 1000).toString()
          }));
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = !isSwitched;
      if (_coinSelected[0] == true) {
        _bitcoinVisible = !_bitcoinVisible;
      } else {
        _ethereumVisible = !_ethereumVisible;
      }
    });
  }

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 5),

                Text(
                  'Give us some details on your proposed Bitcoin Mining Operation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),

                Container(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    children: [
                      Text('Country'),
                      DropdownButton(
                        value: _selectedCountry,
                        onChanged: (String newCountry) {
                          setState(() {
                            _selectedCountry = newCountry;
                            _electricityPrice =
                                Constants.ELECTRICITY_PRICES[_selectedCountry];
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
                  ),
                  Container(
                      width: 150,
                      child: Column(children: [
                        Text("Cryptocurrency Select"),
                        Container(height: 5),
                        ToggleButtons(
                          children: <Widget>[
                            Icon(ToggleIcons.bitcoin),
                            Icon(ToggleIcons.ethereum),
                          ],
                          onPressed: null,
                          /*  (int index) {
                  setState(() {
                    for (int i = 0; i < _coinSelected.length; i++) {
                      if (i == index) {
                        if (_coinSelected[index] != true) {
                          _coinSelected[index] = true;
                        }
                      } else {
                        if (_coinSelected[i] == true) {
                          _coinSelected[i] = false;
                        }
                      }
                    }
                  });
                },*/
                          isSelected: _coinSelected,
                        ),
                      ]))
                ]),

                Container(height: 50),
                Text(
                  'Give us some details about the processors you are looking to use',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Processor type'),
                        DropdownButton(
                          value: _processorSet1.processorType,
                          onChanged: (String newValue) {
                            setState(() {
                              _processorSet1.processorType = newValue;
                              _processorSet1.processor = Constants
                                  .PROCESSORS[_processorSet1.processorType]
                                  .first;
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
                        Text(
                          'Processor',
                          style: TextStyle(color: Colors.green),
                        ),
                        DropdownButton(
                          value: Constants
                                  .PROCESSORS[_processorSet1.processorType]
                                  .contains(_processorSet1.processor)
                              ? _processorSet1.processor
                              : Constants
                                  .PROCESSORS[_processorSet1.processorType]
                                  .first,
                          onChanged: (String newValue) {
                            setState(() {
                              _processorSet1.processor = newValue;
                            });
                          },
                          items: Constants
                              .PROCESSORS[_processorSet1.processorType]
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
                            initialValue: _processorSet1.quantity.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (String newValue) {
                              setState(() {
                                if (newValue != "")
                                  _processorSet1.quantity = int.parse(newValue);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text('Enabled'),
                        Checkbox(
                            value: _processorSet1.enabled,
                            onChanged: (bool newValue) {
                              setState(() {
                                _processorSet1.enabled = newValue;
                              });
                            })
                      ],
                    ),
                    Container(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text('Already Purchased'),
                        Checkbox(
                            value: _processorSet1.alreadyPurchased,
                            onChanged: (bool newValue) {
                              setState(() {
                                _processorSet1.alreadyPurchased = newValue;
                              });
                            })
                      ],
                    ),
                    Container(
                      width: 10,
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
                          value: _processorSet2.processorType,
                          onChanged: (String newValue) {
                            setState(() {
                              _processorSet2.processorType = newValue;
                              _processorSet2.processor = Constants
                                  .PROCESSORS[_processorSet2.processorType]
                                  .first;
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
                        Text(
                          'Processor',
                          style: TextStyle(color: Colors.blue),
                        ),
                        DropdownButton(
                          value: Constants
                                  .PROCESSORS[_processorSet2.processorType]
                                  .contains(_processorSet2.processor)
                              ? _processorSet2.processor
                              : Constants
                                  .PROCESSORS[_processorSet2.processorType]
                                  .first,
                          onChanged: (String newValue) {
                            setState(() {
                              _processorSet2.processor = newValue;
                            });
                          },
                          items: Constants
                              .PROCESSORS[_processorSet2.processorType]
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
                            initialValue: _processorSet2.quantity.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (String newValue) {
                              setState(() {
                                if (newValue != "")
                                  _processorSet2.quantity = int.parse(newValue);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text('Enabled'),
                        Checkbox(
                            value: _processorSet2.enabled,
                            onChanged: (bool newValue) {
                              setState(() {
                                _processorSet2.enabled = newValue;
                              });
                            })
                      ],
                    ),
                    Container(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text('Already Purchased'),
                        Checkbox(
                            value: _processorSet2.alreadyPurchased,
                            onChanged: (bool newValue) {
                              setState(() {
                                _processorSet2.alreadyPurchased = newValue;
                              });
                            })
                      ],
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),

                Container(height: 50),
                Text(
                  'Enter any additional costs associated with running your operation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 150,
                    child: Column(children: [
                      Text("Other Fixed Costs (Daily)"),
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
                      Text("Other Initial Capital Expenses (Daily)"),
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
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height,
                child: VerticalDivider(color: Colors.black)),
            Column(
              children: [
                Container(height: 50),
                Row(
                  children: [
                    Container(child: GroupButton(
                      isRadio: true,
                      spacing: 10,
                      direction: Axis.horizontal,
                      selectedButtons: ["1Y"],
                      onSelected: (index, isSelected) {
                        const _dayMap = {0:7, 1:14, 2:30, 3:90, 4:183, 5:365, 6:730};
                        setState(() {
                          _chartNumberOfDays = _dayMap[index];
                        });
                      },
                      buttons: ["7D", "14D", "1M", "3M", "6M", "1Y", "2Y"],
                    ))
                  ]
                ),
                Container(height: 50),
                Text('Cumulative Profit/Loss',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: _chartWidth,
                  child: getProfitChart(_chartNumberOfDays, true),
                ),

                    Text('Daily Profit/Loss',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: _chartWidth,
                  child: getProfitChart(_chartNumberOfDays, false),
                ),

                // This button toggles if we should show the price history of the
                // coins.
                Container(
                  width: _chartWidth,
                  child: Visibility(
                      visible: _bitcoinVisible,
                      child: Column(
                        children: [
                          Text('Bitcoin Price History',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          getPriceChart(),
                        ],
                      )),
                ),
                // Container(
                //   width: _chartWidth,
                //   child: Visibility(
                //     visible: _bitcoinVisible,
                //     child: Visibility(
                //         visible: _ethereumVisible,
                //         child: Column(
                //           children: [
                //             Text('Ethereum Price History'),
                //             getPriceChart('ethereum', _chartNumberOfDays),
                //           ],
                //         )),
                //   ),
                // ),
              ],
            )
          ])
        ],
      )),
    );
  }

  /// Builds a graph displaying the daily profit of a particular processor in a
  /// particular country.
  ///
  /// The [numberOfDays] is the amount of days to populate the chart with.
  Widget getProfitChart(int numberOfDays, bool isCumulative) {

    return FutureBuilder<http.Response>(
        future: _fetchData(),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            DateTime startDate = chartStartDate(_startDate, numberOfDays);
            // TODO: once we start predicting the future we need to do this differently
            // right now if you set a start date of less than numberOfDays days ago.
            // the start date is set to now - numberOfDays and the end to now
            List<ProcessorSet> processors = [_processorSet1, _processorSet2];
            List<ProfitPerDay> processorSeries = [];
            double cumulativeProfit =
                calculateInitialCapitalExpense(processors) * -1;

            // Go through each value on the priceHistoryRequest per day. The
            // first value in the response is the oldest, the last is the
            // current price.
            Map<String, dynamic> response = jsonDecode(snapshot.data.body);
            // Splice the list so we only get the time period we want
            var scopedList = response['prices'].skip(Constants.DAYS_IN_TWO_YEARS - numberOfDays);
            for (int i = 0; i < scopedList.length; i++) {
              double coinPrice = scopedList[i][1];
              double profitForDay = 0.0;

              profitForDay = calculateProfitForDay(coinPrice, processors);

              cumulativeProfit += profitForDay;

              double dataPoint = 0.0;
              if (isCumulative) {
                dataPoint = cumulativeProfit;
              } else {
                dataPoint = profitForDay;
              }

              processorSeries.add(ProfitPerDay(
                startDate.add(Duration(days: i)),
                dataPoint,
                profitForDay >= 0 ? Colors.green : Colors.redAccent,
              ));
            }
            List<List<ProfitPerDay>> series = [processorSeries];
            return ProfitChart(series, 'Time', 'Profit (AU\$)');
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container();
          }
        });
  }

  double calculateInitialCapitalExpense(List<ProcessorSet> processors) {
    double totalInitialCapitalExpense = _otherCapitalExpenses;

    for (var i = 0; i < processors.length; i++) {
      if (processors[i].enabled && !processors[i].alreadyPurchased) {
        totalInitialCapitalExpense +=
            Constants.INITIAL_CAPITALS[processors[i].processor];
      }
    }

    return totalInitialCapitalExpense;
  }

  /// Returns the amount of profit made for a specific day.
  double calculateProfitForDay(
      double coinPrice, List<ProcessorSet> processors) {
    return calculateIncomeForDay(coinPrice, processors) -
        calculateCostForDay(processors);
  }

  /// Returns the cost (in electricity) for 24 hours of use.
  double calculateCostForDay(List<ProcessorSet> processors) {
    double totalFixedCosts = _otherFixedCosts;

    // Calculate the fixed daily costs of running all of the enabled processors
    for (var i = 0; i < processors.length; i++) {
      if (processors[i].enabled) {
        totalFixedCosts += (_electricityPrice / Constants.WATTS_IN_KILOWATT) *
            Constants.HOURS_IN_DAY *
            Constants.POWER_USAGES[processors[i].processor] *
            processors[i].quantity;
      }
    }

    return totalFixedCosts;
  }

  /// Returns the income generated from 24 hours of hashing.
  double calculateIncomeForDay(
      double coinPrice, List<ProcessorSet> processors) {
    double totalIncome = 0;

    // Calculate the fixed daily income generated from running all of the enabled processors
    processors.forEach((processor) {
      if (processor.enabled) {
        totalIncome += Constants.BITCOIN_BLOCK_REWARD *
            (Constants.MINUTES_IN_DAY / Constants.BITCOIN_AVG_BLOCKTIME) *
            (Constants.HASH_RATES[processor.processor] /
                Constants.NETWORK_HASHRATE) *
            coinPrice *
            processor.quantity;
      }
    });

    return totalIncome;
  }

  /// Builds a graph displaying the price history of a [coin] for the past 30
  /// days.
  Widget getPriceChart() {
    return FutureBuilder<http.Response>(
        future: _fetchData(),
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
    var scopedList = prices.skip(Constants.DAYS_IN_TWO_YEARS - _chartNumberOfDays);
    var series = <ProfitPerDay>[];
    scopedList.forEach((element) => series.add(ProfitPerDay(
        DateTime.fromMillisecondsSinceEpoch(element[0]),
        element[1],
        Colors.blue)));
    return series;
  }

  /// Calculate a sensible date for the chart to start
  /// TODO: predict the future and deprecate this function
  DateTime chartStartDate(DateTime startingDate, int numberOfDays) {
    var nDaysAgo = DateTime.now().subtract(Duration(days: numberOfDays));
    if (startingDate.isAfter(nDaysAgo)) {
      return nDaysAgo;
    } else {
      return startingDate;
    }
  }

  /// Calculate a sensible date for the chart to end
  /// TODO: predict the future
  DateTime chartEndDate(DateTime startingDate, int numberOfDays) {
    var nDaysAgo = DateTime.now().subtract(Duration(days: numberOfDays));
    if (startingDate.isAfter(nDaysAgo)) {
      return DateTime.now();
    } else {
      return startingDate.add(Duration(days: numberOfDays));
    }
  }
}
