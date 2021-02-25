import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './data/listdata.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  PageController controller = PageController();
  List<ListData> list;
  var itemCount;

  @override
  void initState() {
    itemCount = 0;
    list = List<ListData>();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                onPressed: () {
                  if (controller.page.toInt() != 0) {
                    controller.jumpToPage(controller.page.toInt() - 1);
                  }
                },
                child: Text("Prev"),
              ),
              RaisedButton(
                onPressed: () {
                  if (controller.page.toInt() != (list.length / 4).toInt()) {
                    controller.jumpToPage(controller.page.toInt() + 1);
                  }
                },
                child: Text("Next"),
              )
            ],
          ),
          Flexible(
            child: PageView.builder(
              physics: new NeverScrollableScrollPhysics(),
              controller: controller,
              itemCount: (list.length / 4).toInt() + 1,
              itemBuilder: (context, position) {
                return Container(
                  child: ListView.builder(
                      itemCount: getItemCount(position),
                      itemBuilder: (context, index) {
                        index = 4 * position + index;

                        return Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: ListTile(
                              title: Text(list[index].name),
                              subtitle: Text(list[index].email),
                              isThreeLine: true,
                              trailing: Text(list[index].address.city),
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getData() async {
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/users");
    List<dynamic> jsonlist = json.decode(response.body.toString());
    jsonlist.forEach((element) {
      list.add(ListData.fromJson(element));
    });
    setState(() {
      itemCount = list.length;
    });
  }

  getItemCount(int position) {
    var startPosition = position * 4;
    if (startPosition + 4 > list.length) {
      return list.length - startPosition;
    } else {
      return 4;
    }
  }
}
