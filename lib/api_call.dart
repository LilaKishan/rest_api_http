import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rest_api/add_user.dart';

class ApiCall extends StatefulWidget {
  @override
  State<ApiCall> createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {
  var url = 'https://631327f4a8d3f673ffc55a53.mockapi.io/student';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => AddUser(null),
                  ),
                )
                    .then(
                  (value) {
                    setState(() {
                      getDataFromWebServer();
                    });
                  },
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<http.Response>(
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.hasData) {
            return ListView.builder(
              itemCount: jsonDecode(snapshot.data!.body.toString()).length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (jsonDecode(snapshot.data!.body.toString())[
                                        index]['name']
                                    .toString()),
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                          index]['department']
                                      .toString()),
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                  (convertDateFromString(jsonDecode(snapshot
                                          .data!.body
                                          .toString())[index]['dob']
                                      .toString())),
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: AlertDialog(
                                    title: Text('Are you sure?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            deleteUser((jsonDecode(snapshot
                                                    .data!.body
                                                    .toString())[index]['id']))
                                                .then(
                                              (value) {
                                                setState(() {
                                                  getDataFromWebServer();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            );
                                          },
                                          child: Text('Yes'))
                                    ]),
                              );
                            },
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => AddUser(
                                    jsonDecode(snapshot.data!.body)[index]),
                              ),
                            )
                                .then(
                              (value) {
                                setState(() {});
                              },
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getDataFromWebServer(),
      ),
    );
  }

  String convertDateFromString(String dateToFormat) {
    DateTime date =
        DateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'").parse(dateToFormat);
    return DateFormat("dd-MMM-yyyy").format(date);
  }

  Future<http.Response> getDataFromWebServer() async {
    var response = await http.get(Uri.parse(url));
    //print(response.body.toString());

    return response;
  }

  Future<void> deleteUser(id) async {
    var response = await http.delete(
        Uri.parse("https://631327f4a8d3f673ffc55a53.mockapi.io/student/${id}"));
  }
}
