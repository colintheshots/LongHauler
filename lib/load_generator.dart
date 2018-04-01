import 'dart:math';

import 'package:long_hauler/load.dart';

class LoadGenerator {
  var _nextId = 1;
  var descriptionList = const [
    "binders full of women",
    "tiny Trump memes",
    "packets of McDonald's Szechuan sauce",
    "Andy Android dolls",
    "jars of Kotlin-brand ketchup",
    "trendy MinneBar t-shirts",
    "pints of overhopped IPA beer",
    "well-hidden easter eggs"
  ];

  Load generateLoad() {
    int newId = newLoadId();
    var random = new Random();
    int value = random.nextInt(10000);
    int expires = new DateTime.now().millisecondsSinceEpoch + random.nextInt(100000);
    int distance = random.nextInt(10000);
    String description = descriptionList[random.nextInt(descriptionList.length - 1)];
    return new Load(newId, value, expires, distance, description);
  }

  List<Load> generateLoads(int i) {
    return new List.generate(i, (int index) => generateLoad());
  }

  int newLoadId() {
    int _currentId = _nextId;
    _nextId++;
    return _currentId;
  }
}