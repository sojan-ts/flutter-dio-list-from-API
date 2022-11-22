import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dio_listview_json/model.dart';
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Dio List Sample"),
      ),
      body: futureBuilder,
    );
  }

  Future<List<Photo>> _getData() async {
    var values = <Photo>[];

    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/photos/');
      String arr = jsonEncode(response.data);
      final data = jsonDecode(arr);

      data.forEach((item) {
        values
            .add(Photo(id: item['id'], title: item['title'], url: item['url']));
      });
    } catch (e) {
      print("you have an error dude");
    }

    return values;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Photo> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(values[index].title),
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
  }
}
