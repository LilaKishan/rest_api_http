import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  AddUser(this.map);

  Map? map;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  void initState() {
    super.initState();
    nameController.text =
        widget.map == null ? "" : widget.map!['name'].toString();
    departmentController.text =
        widget.map == null ? "" : widget.map!['department'].toString();
    rollnoController.text =
        widget.map == null ? "" : widget.map!['rollno'].toString();
    dobController.text =
        widget.map == null ? "" : widget.map!['dob'].toString();
    imgPathController.text =
        widget.map == null ? "" : widget.map!['studentimg'].toString();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController imgPathController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return 'Enter valid Name';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter  Name",
              ),
            ),
            //username
            SizedBox(height: 20),
            TextFormField(
              controller: departmentController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return 'Enter valid departmentName';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "department",
              ),
            ),
            //department
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: rollnoController,
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return 'Enter valid rollno';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Roll no",
              ),
            ),
            //rollno
            SizedBox(height: 20),
            TextFormField(
              controller: dobController,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return 'Enter valid date';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "DOB",
              ),
            ),
            //dob
            SizedBox(height: 20),
            TextFormField(
              controller: imgPathController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return 'Enter valid path';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Studentimgpath',
              ),
            ),
            //studentimgpath
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.map == null) {
                      addUser().then(
                        (value) => Navigator.of(context).pop(),
                      );
                    } else {
                      updateUser(widget.map!['id']).then(
                        (value) => Navigator.of(context).pop(),
                      );
                    }
                  }
                });
              },
              child: Text('Add'),
            )
            //submit
          ]),
        ),
      ),
    );
  }

  Future<void> addUser() async {
    Map map = {};
    map['name'] = nameController.text;
    map['department'] = departmentController.text;
    map['rollno'] = rollnoController.text;
    map['dob'] = dobController.text;
    map['studentimg'] = imgPathController.text;

    var response1 = await http.post(
        Uri.parse("https://631327f4a8d3f673ffc55a53.mockapi.io/student"),
        body: map);
    print(response1.body);
  }

  Future<void> deleteUser(id) async {
    var response = await http.delete(
        Uri.parse("https://631327f4a8d3f673ffc55a53.mockapi.io/student/${id}"));
  }

  Future<void> updateUser(id) async {
    Map map = {};
    map['name'] = nameController.text;
    map['department'] = departmentController.text;
    map['rollno'] = rollnoController.text;
    map['dob'] = dobController.text;
    map['studentimg'] = imgPathController.text;

    var response1 = await http.put(
        Uri.parse("https://631327f4a8d3f673ffc55a53.mockapi.io/student/${id}"),
        body: map);
    print(response1.body);
  }
}
