import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/utils.dart' as utils;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _cityEntered;

  Future _gotoNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    setState(() {
      if (results != null && results.containsKey('enter')) {
        _cityEntered = results['enter'];
        print(results['enter'].toString());
      }
    });
  }

  void showData() async {
    Map data = await getweather(utils.appId, utils.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _gotoNextScreen(context),
          )
        ],
      ),
      body: new Stack(
        children: [
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              height: 1200.0,
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 40.0, 20.9, 0.0),
            child: new Text(
                "${_cityEntered == null ? utils.defaultCity : _cityEntered}",
                style: cityStyle()),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
          updateTempWidget(_cityEntered),
//          new Container(
//            child:
//          )
        ],
      ),
    );
  }

  Future<Map> getweather(String appId, String city) async {
    String appUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${utils.appId}&units=metric";

    http.Response response = await http.get(appUrl);

    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future:
            getweather(utils.appId, city == null ? utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //This is where we get all of our json data, and Setup our widget etc..
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(content["main"]["temp"].toString() + "C",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 49.9,
                        )),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content["main"]['humidity'].toString()}\n"
                        "Min: ${content["main"]['temp_min'].toString()}C\n"
                        "Max: ${content["main"]['temp_max'].toString()}C",
                        style: extraData(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

// ignore: must_be_immutable
class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Stack(
        children: [
          new Center(
            child: new Image.asset(
              "images/white_snow.png",
              height: 1200.0,
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                  title: new TextField(
                decoration: InputDecoration(
                  hintText: 'Enter City',
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              )),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                  },
                  child: new Text('Get weather'),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle extraData() {
  return new TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.italic,
    fontSize: 18.0,
  );
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 23.0, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 50.0,
    fontWeight: FontWeight.w500,
  );
}
