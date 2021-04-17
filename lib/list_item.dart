import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItem extends StatefulWidget {
  ListItem({Key key, this.onValueChanged, this.onRemoved}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Function(double) onValueChanged;
  final Function(ListItem) onRemoved;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  /*
  Might need to have country pre-selected before going into the main screen.
  Passing country value from one Widget to a list seems too hard :(
   */
  String selectedCountry = 'Australia';

  var _processorTypes = ['ASIC', 'GPU', 'CPU'];
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
  var _electricityPrices = {
    'Australia' : 0.002,
    'China' : 0.001,
    'USA' : 0.003
  };

  double _moneyPerMegahash = 5 / 3600;
  int _hoursInMonth = 24 * 30;

  String _selectedProcessor = 'GTX 1080 Ti';
  String _selectedProcessorType = 'GPU';
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              child: DropdownButton(
                value: _selectedProcessorType,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedProcessorType = newValue;
                    _selectedProcessor = _processors[_selectedProcessorType].first;
                  });
                  widget.onValueChanged(calculateIncome() - calculateCosts());
                },
                items: _processorTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 125,
              child: DropdownButton(
                value: _processors[_selectedProcessorType].contains(_selectedProcessor) ? _selectedProcessor : _processors[_selectedProcessorType].first,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedProcessor = newValue;
                  });
                  widget.onValueChanged(calculateIncome() - calculateCosts());
                },
                items: _processors[_selectedProcessorType].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 75,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                initialValue: '0',
                onChanged: (value) {
                  if (value == "") {
                    setState(() {
                      _quantity = 0;
                    });
                    widget.onValueChanged(calculateIncome() - calculateCosts());
                  } else {
                    setState(() {
                      _quantity = int.parse(value);
                    });
                    widget.onValueChanged(calculateIncome() - calculateCosts());
                  }
                },
              ),
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 100,
              child: Text('\$' + calculateCosts().toStringAsFixed(2)),
            ),
            Container(
              width: 50,
            ),
            Container(
              width: 100,
              child: Text('\$' + calculateIncome().toStringAsFixed(2)),
            ),
            Container(
              width: 50,
              child: TextButton(
                  onPressed: () {
                    widget.onRemoved(widget);
                  },
                  child: Text('X', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
            )
          ],
        ),
      ],
    );
  }

  double calculateCosts() {
    double _electricityPrice = _electricityPrices[this.selectedCountry];

    return _quantity * _electricityPrice * _hoursInMonth * _powerUsages[_selectedProcessor];
  }

  double calculateIncome() {
    return _quantity * _moneyPerMegahash * _hoursInMonth * _hashRates[_selectedProcessor];
  }
}