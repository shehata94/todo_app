import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/todo_app/archived_tasks/archived_tasks.dart';
import 'package:todo_app/todo_app/done_tasks/done_tasks.dart';
import 'package:todo_app/todo_app/new_tasks/new_tasks.dart';

class AppLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<AppLayout> {
  List<Widget> screen = [NewTasks(), DoneTasks(), ArchivedTasks()];
  var currentIndex = 0;
  Database db;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    createDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState.validate()) {
              insertDB(name: titleController.text, time: timeController.text, date: dateController.text).then((value) {
                getFromDB(db).then((value) {
                  Navigator.of(context).pop();
                  fabIcon = Icons.edit;
                  setState(() {});
                  isBottomSheetShown = false;
                });
              }).catchError((e) {
                print('error $e');
              });
            }
          } else {
            fabIcon = Icons.add;
            setState(() {});
            scaffoldKey.currentState
                .showBottomSheet((context) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey[100],
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextForm(
                              controller: titleController,
                              inputType: TextInputType.text,
                              prefix: Icons.title,
                              label: 'Title',
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Title must not be empty";
                                }
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          defaultTextForm(
                              controller: timeController,
                              inputType: TextInputType.text,
                              prefix: Icons.watch_later_outlined,
                              label: 'Time',
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Time must not be empty";
                                }
                              },
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value.format(context).toString();
                                  print(value.format(context).toString());
                                }).catchError((error) {
                                  print(error.toString());
                                });
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          defaultTextForm(
                              controller: dateController,
                              inputType: TextInputType.text,
                              prefix: Icons.date_range_outlined,
                              label: 'Date',
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Date must not be empty";
                                }
                              },
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2021-12 -03"))
                                    .then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value);
                                });
                              }),
                        ],
                      ),
                    ),
                  );
                })
                .closed
                .then((value) {
                  fabIcon = Icons.edit;
                  setState(() {});
                  isBottomSheetShown = false;
                });
            isBottomSheetShown = true;
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {});
          currentIndex = value;
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.date_range_outlined,
              ),
              label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.done,
              ),
              label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: 'Archive')
        ],
      ),
      body: tasks.length > 0 ? screen[currentIndex] : Center(child: CircularProgressIndicator()),
    );
  }

  // Create and open databse
  void createDB() async {
    db = await openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) => print('Table created successfully'))
          .catchError((onError) => print(onError.toString()));
    }, onOpen: (database) {
      getFromDB(database).then((value) {
        tasks = value;
      });
      print('Table opened successfully');
      print('here are the records $tasks');
    });
  }

//Insert record in database
  Future insertDB({@required String name, @required String time, @required String date}) async {
    return await db.transaction((txn) {
      txn
          .rawInsert('INSERT INTO tasks (name , time, date, status) VALUES("$name","$time","$date","new")')
          .then((value) => print('$value record inserted successfully'))
          .catchError((error) {
        print('Error when inserting to database $error');
      });
      return null;
    });
  }

  //Get Records from database
  Future<List<Map>> getFromDB(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
//Update record in database
//Delete record from database
}
