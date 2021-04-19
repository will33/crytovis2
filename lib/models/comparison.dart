import 'dart:collection';

import 'package:flutter/material.dart';

class ComparisonModel extends ChangeNotifier {
  final List<Item> _items = [];
  final Configuration _configuration;

  ComparisonModel(this._configuration);

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  int get totalCost => _items.fold(0, (previousValue, element) => previousValue + (element.quantity * element.processor.powerUsage * _configuration.electricityPrice));

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void modify(Item oldItem, Item newItem) {
    // Todo
    notifyListeners();
  }

  double getItemCost(Item item) {
    return 0;
  }
}

class Item {
  Processor processor;
  int quantity;

  Item(this.processor, this.quantity);
}

class Processor {
  String type;
  String name;
  double hashrate;
  int powerUsage;

  Processor(this.type, this.name, this.hashrate, this.powerUsage);
}

class Configuration {
  int electricityPrice;

  Configuration(this.electricityPrice);
}
