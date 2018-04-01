import 'dart:async';

import 'package:flutter/material.dart';
import 'package:long_hauler/load.dart';
import 'package:long_hauler/load_generator.dart';

void main() => runApp(new LongHaulerApp());

class LongHaulerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Long Hauler',
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {

  PageController _pageController;
  final _suggestions = <Load>[];
  final _saved = new Set<Load>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _pageTitles = [
    "Loads",
    "Log Book"
  ];
  var _money = 0;
  var _loadGenerator = new LoadGenerator();
  var _currentPage = 0;
  var _log = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Long Hauler - \$${_money}"),),
      body: new PageView(
          children: [new Container(
            child: new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _suggestions.length * 2,
                itemBuilder: (context, i) {
                  if (i.isOdd) return new Divider();
                  final index = i ~/ 2;
                  return _buildRow(_suggestions[index]);
                }
            ),
          ), new Container(
            color: Colors.grey,
            child: new ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, i) {
                return new ListTile(
                  title: new Text(_log[_log.length - i - 1]),
                );
              }))],
          /// Specify the page controller
          controller: _pageController
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.add),
              title: new Text(_pageTitles[0])
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.list),
              title: new Text(_pageTitles[1])
          )
        ],
        /// Will be used to scroll to the next page
        /// using the _pageController
        onTap: navigationTapped,
      )
    );
  }

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// page index
  void navigationTapped(int page){
    setState(() {_currentPage = page;});

    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    initLoadGenerator();
  }

  void initLoadGenerator() {
    new Future.delayed(const Duration(seconds: 2),
    () {
      setState((){
        _suggestions.add(_loadGenerator.generateLoad());
      });
    }).then((_) => initLoadGenerator());
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  Widget _buildRow(Load load) {
    return new Dismissible(key: new Key(load.id.toString()),
        onDismissed: (DismissDirection direction) {
          setState(() {
            _accept(load);
          });
        },
        child: new ListTile(
          title: new Text(
            "a trailer full of ${load.description}",
            style: _biggerFont,
          ),
          subtitle: new Text(
            "\$${load.value}",
            style: _biggerFont,
          ),
          onTap: () {
            setState(() {
              _accept(load);
            });
          },
        )
    );
  }

  void _accept(Load load) {
    setState((){
      _saved.remove(load);
      _suggestions.remove(load);
      _money += load.value;
      _log.add("completed '${load.description}' for \$${load.value}");
    });
  }
}