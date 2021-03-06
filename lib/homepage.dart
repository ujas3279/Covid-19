import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import './pages/statePage.dart';
import './pannels/infopanel.dart';
import './datasource.dart';
import './pannels/mostaffectedstates.dart';
import './pannels/worldwidepannel.dart';

//Map worldData;
//List stateData;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response =
        await http.get('https://api.covid19india.org/data.json');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List stateData;
  Map data;
  fetchstateData() async {
    http.Response response =
        await http.get('https://api.covid19india.org/data.json');
    setState(() {
      data = json.decode(response.body);
      stateData = data["statewise"];
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchstateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          Container(
              padding: const EdgeInsets.all(20.0),
              child: Text('Covid 19 Tracker')),
          Container(
              padding: EdgeInsets.only(left: 50),
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    fetchWorldWideData();
                    fetchstateData();
                    Fluttertoast.showToast(
                        msg: "Data Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 2,
                        backgroundColor: Colors.blue[50],
                        textColor: Colors.black,
                        fontSize: 16.0);
                  }))
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              color: Colors.orange[100],
              child: Text(
                DataSource.quote,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    'assets/1.jpg',
                    height: 50.0,
                    width: 100.0,
                  ),
                  Text(
                    "INDIA",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryblack,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        child: Text(
                          "Regional",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => StatePage()));
                        },
                      )),
                ],
              ),
            ),
            worldData == null
                ? Center(child: CircularProgressIndicator())
                : WorldwidePannel(
                    worldData: worldData,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Most affected states",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            stateData == null
                ? Center(child: CircularProgressIndicator())
                : MostAffectedPanel(
                    stateData: stateData,
                  ),
            InfoPanel(),
            SizedBox(
              height: 20.0,
            ),
            Center(
                child: Text(
              "WE ARE TOGETHER IN THE FIGHT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
